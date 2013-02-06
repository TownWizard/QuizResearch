class QuizzesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  @@error_map = {
    '400' => {
      'quiz_id' => 'Please select a quiz before continuing.',
      'user_id' => 'You must supply valid user credentials before continuing.',
      'qiid' => 'We were unable to identify the requested instance of the requested survey.',
      'questions' => 'Please complete all questions before continuing.',
      'answers' => 'Please complete all questions before continuing.',
      'default' => 'We were unable to match the answers provided to the current survey.  Please try again.'
    },
    '500' => {
      'default' => 'An unknown error occurred.  Please try your request again.'
    },
    '404' => {
      'default' => 'The survey you requested was not found.  Please check the URL and try again.'
    }
  }

  before_filter :create_http_agent
  before_filter :build_request_cookie_string

  def create
    quiz_post_uri = params[ :submit_to ]

    agent = Mechanize.new

    t_params = params.except( :controller, :action )

    query_to_post = {}
    #seed query with new user id
    t_params.each_pair do |k,v|
      if k == "lqa"
        query_to_post[ 'lqa' ] = params[ :lqa ]
      else
        query_to_post[ k ] = v
      end
    end

    RAILS_DEFAULT_LOGGER.info "----------"
    RAILS_DEFAULT_LOGGER.info "Proxying quiz create submission to: #{quiz_post_uri}"
    RAILS_DEFAULT_LOGGER.info "----------"

    post_request = agent.post( quiz_post_uri, query_to_post )

    RAILS_DEFAULT_LOGGER.info "----------"
    RAILS_DEFAULT_LOGGER.info post_request.content
    RAILS_DEFAULT_LOGGER.info "----------"

    headers[ 'Set-Cookie' ] = @request_cookie_str

    @xml = Nokogiri::XML( post_request.content )

    tqiid = @xml.xpath( "/quiz_request/quiz_request_metadata/quiz_instance_uuid" )[0].content
    position = @xml.xpath( "/quiz_request/quiz_phase/position" )[0].content
    redirect_to :action => :show, :qiid => tqiid, :position => position

  end
  
  def index
  end

  def start
    version_url_part=""
    version_url_part = "/v/#{params[:api_version]}" unless params[:api_version].blank?
    partner_site = ::PartnerSite.find(:first, :conditions => {:domain => request.domain(1), :host => request.subdomains(1).first, :deleted_at => nil})

    if partner_site.nil?
      flash[:notice] = "Sorry page does not exist"
      render :action => :index and return
    end
    session[:quizzila_url] = "http://#{partner_site.host}.quizilla.#{partner_site.domain}#{ENV[ 'qport' ]}/quizzes#{version_url_part}"
#    session[:quizzila_url] = "http://#{params[:partner_site]}#{ENV[ 'qport' ]}/quizzes#{version_url_part}"

    @options[ :url ] = "#{session[:quizzila_url]}"
    @catalog_request = @agent.get( @options )

    RAILS_DEFAULT_LOGGER.info @catalog_request.body
    xml_doc = Nokogiri::XML( @catalog_request.body )

    # Create a new XSL Transform
    stylesheet = Nokogiri::XSLT( File.read( "public/stylesheets/catalog.xsl" ) )

    # Transform a xml document
    output = stylesheet.transform xml_doc

    render :inline => output.to_s + "<hr /><pre>" + CGI.escapeHTML(xml_doc.to_s) + "</pre>"

  end

  def show
    @options[ :url ] = "#{session[:quizzila_url]}/open/#{params[ :qiid ]}/#{params[ :position ]}/?format=xml&errors=#{flash[:errors]}&submitted_answers=#{flash[ :submitted_answers ]}&free_text_answers=#{flash[ :free_text_answers ]}"
    
    @catalog_request = @agent.get( @options )
    
    xml_doc   = Nokogiri::XML( @catalog_request.body )
    # Create a new XSL Transform
    stylesheet = Nokogiri::XSLT( File.read( "public/stylesheets/quiz_page.xsl" ) )

    if xml_doc.xpath( '//quiz_request_metadata' )
      tqiid = xml_doc.xpath( "/quiz_request/quiz_request_metadata/quiz_instance_uuid" )[0].content
      tposition = xml_doc.xpath( "/quiz_request/quiz_phase/position" )

      if tposition.size > 0
        if tposition[ 0 ].content.to_i > 1
          @previous_position = tposition[ 0 ].content.to_i - 1
        else
          @previous_position = nil
        end
      end

      if @previous_position
        @previous_page_uri = "/quizzes/#{tqiid}/#{@previous_position}"
      end

      resume_present = xml_doc.xpath( "/quiz_request/quiz_request_metadata/resume_quiz_uri" )
      if resume_present.size > 0
        resume_position = resume_present[0].content.match( /\/([0-9])\Z/ )
        resume_uri = "/quizzes/#{tqiid}/#{resume_position}"
      end
    end
    
    # Transform a xml document
    output = stylesheet.transform( xml_doc, Nokogiri::XSLT.quote_params( [ 'previous_page_uri', @previous_page_uri.to_s, 'resume_uri', resume_uri ] ) )
    render :inline => output.to_s + "<hr /><pre>" + CGI.escapeHTML(xml_doc.to_s) + "</pre>"
  end

  def submit

    quiz_post_uri = params[ :submit_to ]
    
    agent = WWW::Mechanize.new

    t_params = params.except( :controller, :action )

    #seed query with new user id
    query_to_post = {}
    t_params.each_pair do |k,v|
      if k == "questions"
        v.each_pair do |x,y|
          query_to_post[ "questions[#{x}]" ] = y.collect {|a| a }.join ','
        end
      elsif k == "answer"
        v.each_pair do |x,y|
          query_to_post[ "answer[#{x}]" ]=y
        end
      else
        query_to_post[ k ] = v
      end
    end

    xml_to_parse = agent.post( quiz_post_uri, query_to_post )
    
    RAILS_DEFAULT_LOGGER.info "----------"
    RAILS_DEFAULT_LOGGER.info xml_to_parse.content
    RAILS_DEFAULT_LOGGER.info "----------"
    
    xml_object = Nokogiri::XML( xml_to_parse.content )
    #@xml = xml_object.parse

    if xml_object.xpath( "/errors" ).size > 0
      #flash[ :email ] = params[ :user ][ :email ]
      flash[ :errors ] = []

      # lets map these errors over to something more friendly for the user.
      # Trying to think of a good way to do this. for now, let's use a
      # combo of field / code.
      
      xml_object.xpath( "/errors//error" ).each do |e|
        flash[ :errors ] << map_errors( e )
      end
     
      # collect submitted answers for inclusion in flash.
      flash[ :free_text_answers ] = Hash.new
      if params[ :questions ]
        flash[ :submitted_answers ] = params[ :questions ].collect { |q,v| v }.join ','
        flash[ :free_text_answers ] = params[ :answer ].collect { |q,v| "#{q}=#{v}" }.join ',' unless params[ :answer ].nil?
      end

      redirect_to :back and return
    else

      if( xml_object.xpath( "//completed_quiz_result" )[0] )
        #qiid = xml_object.xpath( "/quiz_request/quiz_request_metadata/quiz_instance_uuid" )[0].content
        redirect_to "/quizzes/#{params[ :qiid ]}/result" and return
      else
        qiid = xml_object.xpath( "/quiz_request/quiz_request_metadata/quiz_instance_uuid" )[0].content
        position = xml_object.xpath( "/quiz_request/quiz_phase/position" )[0].content
        redirect_to "/quizzes/#{qiid}/#{position}" and return
      end

    end

    # now transform the output
    # Create a new XSL Transform
    stylesheet = Nokogiri::XSLT( File.read( "public/stylesheets/quiz_page.xsl" ) )
    output = stylesheet.transform xml_object
    # Transform a xml document

    render :inline => output.to_s + "<hr /><pre>" + CGI.escapeHTML(xml_object.to_s) + "</pre>"

  end

  def result
    @request = Mechanize.new.get( "#{session[:quizzila_url]}/open/#{params[ :qiid ]}/#{params[ :position ]}" )

    RAILS_DEFAULT_LOGGER.info @request.body

    xml_doc   = Nokogiri::XML( @request.body )
    stylesheet = Nokogiri::XSLT( File.read( "public/stylesheets/quiz_result.xsl" ) )

    output = stylesheet.transform( xml_doc )

    render :inline => output.to_s + "<hr /><pre>" + CGI.escapeHTML(xml_doc.to_s) + "</pre>"
  end

  private

  def create_http_agent
    @agent = Mechanize.new
    @options = {}
  end

  # builds a Set-Cookie header in the @options hash, to be sent along with
  # posts to the quiz service
  def build_request_cookie_string
    cookie_proxy_string_parts = []
    cookies.each do |n,v|
      if !n.match( /_session\Z/ )
        cookie_proxy_string_parts << "#{n}=#{v} path=/"
      end
    end

    if cookie_proxy_string_parts.size > 0
      @request_cookie_str = cookie_proxy_string_parts.join( '; ' )
    end

    @request_cookie_str
    #@options[ :headers ] = { 'Cookie', cookie_str }
  end

  
  def base_quiz_request_uri
    @base_quiz_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}#{ENV[ 'qport' ]}"
    #@base_quiz_request_uri = "http://173.45.232.198"
  end

  def map_errors error
    #debugger
    code = error.xpath( 'code' )[ 0 ].content
    field = error.xpath( 'field' )[ 0 ].content
    
    if field
      msg = @@error_map[ code ][ field ]
    else
      msg = @@error_map[ code ][ 'default' ]
    end
    msg
  end

end
