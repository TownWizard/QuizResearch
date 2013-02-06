class QuizzesController < ApplicationController
  before_filter :create_http_agent
  before_filter :load_quiz, :only => [:start, :show, :new, :submit_answers, :result]

  before_filter :ensure_authenticated_to_facebook, :only => [:result]

  @@uuid_generator = UUID.new

  def index
    # Following line does not access any user information but it is very helpful to reset a fb cookie
    # As per general behavior, facebook sends +signed_request+ with root url of application
    # So if user is asked for the permissions on root page, there is no issue
    # But in case of this application, user is asked for the permissions only before showing result page
    # which does not have params containing +signed_request+. Thus +mogli+ fails to reset fbcookie at this point
    # And if user might have already de-authorized the app, then system would not know about this
    # with continuing to show result page and fails as there is no real authenticated user
    # To avoid such a situation, this code snippet only reset +fbcookie+ as this action contains +signed_request+ too
    current_facebook_user

    partner_site = ::PartnerSite.find(:first, :conditions => {:domain => request.domain(1), :host => request.subdomains(1).first, :deleted_at => nil})
    if partner_site.nil?
      flash[:notice] = "Sorry page does not exist"
      render :action => :index and return
    end
    session[:quizzila_url] = "http://#{partner_site.host}.quizilla.#{partner_site.domain}#{ENV[ 'qport' ]}/quizzes?facebook_quiz=1"

    @options[ :url ] = session[:quizzila_url]
    @catalog_request = @agent.get( @options )
    @xml = Nokogiri::XML( @catalog_request.body )
  end

  def app_index
    partner_site = ::PartnerSite.find(:first, :conditions => {:domain => request.domain(1), :host => request.subdomains(1).first, :deleted_at => nil})

    if partner_site.nil?
      flash[:notice] = "Sorry page does not exist"
      render :action => :index and return
    end
    session[:quizzila_url] = "http://#{partner_site.host}.quizilla.#{partner_site.domain}#{ENV[ 'qport' ]}/quizzes?facebook_quiz=1"

    @options[ :url ] = session[:quizzila_url]
    @catalog_request = @agent.get( @options )
    @xml = Nokogiri::XML( @catalog_request.body )
    render :layout => 'app_about'
  end

  def start
    if @quiz
      # First create quiz instance before starting a quiz as lead phase is not going to be displayed
      @quiz_instance = QuizInstance.create(
        :quiz_id => @quiz.id,
        :quiz_instance_uuid => @@uuid_generator.generate( :compact ),
        :partner_site_id => @partner_site.id,
        :user_id => current_user.try(:id)
      )
      session[:quiz_instance_uuid] = @quiz_instance.quiz_instance_uuid
      # Create facebook instance with quiz and quiz_instance details
      # If user is already logged in, its information will be stored at this point itself
      facebook_instance = FacebookInstance.create(
        :quiz_instance_uuid => @quiz_instance.quiz_instance_uuid,
        :quiz_instance_id => @quiz_instance.id,
        :facebook_quiz_id => FacebookQuiz.find_by_quiz_id_and_partner_site_id(@quiz.id, @partner_site.id).id,
        :user_id => current_user.try(:id)
      )
      session[:facebook_instance_id] = facebook_instance.id
      redirect_to "/quizzes/#{@quiz.id}/1"
    else
      render '404'
    end
  end

  def show
    if @quiz
      @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"
      
      if params[ :position ]
        quiz_request_uri = "#{ENV[ 'qport' ]}/quizzes/open/#{session[ :quiz_instance_uuid ]}/#{params[ :position ]}/?format=xml"
      end

      #create a new instance of mechanize to gather the xml for us
      agent = Mechanize.new
      agent.basic_auth 'demouser', 'demopass'

      RAILS_DEFAULT_LOGGER.info "Quiz Request URI: #{@base_request_uri}#{quiz_request_uri}"
      xml_to_parse = agent.get( "#{@base_request_uri}#{quiz_request_uri}" )

      RAILS_DEFAULT_LOGGER.info "----------"
      RAILS_DEFAULT_LOGGER.info xml_to_parse.content
      RAILS_DEFAULT_LOGGER.info "----------"

      #turn it into something useful for display
      @xml = Nokogiri::XML( xml_to_parse.content )
    else
      render '404'
    end
  end

  def submit_answers
    if @quiz
      #build useful URLS.  base_uri needs to be available to the view as well
      @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"

      #quiz_post_uri = "http://#{@partner_site.host}.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml&amp;survey_id=#{@survey.id}"
      quiz_post_uri = ""
      if params[ :position ]
        quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/#{session[ :quiz_instance_uuid ]}/#{params[ :position ]}?format=xml"
      else
        quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml"
      end

      #create a new instance of mechanize to gather the xml for us
      agent = Mechanize.new
      agent.basic_auth 'demouser', 'demopass'
      #collect the quiz xml

      # mechanize munges nested hashes in params, so we have to set up a new
      # param hash.
      t_params = params.except( :controller, :action )

      q = Hash["questions", Hash[params[:question_id], [params[:answer_id]]]]

      t_params.delete("question_id")
      t_params.delete("answer_id")

      t_params = t_params.merge!(q)
          
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
        
      RAILS_DEFAULT_LOGGER.info "----------"
      RAILS_DEFAULT_LOGGER.info "Proxying submission to: #{quiz_post_uri}"
      RAILS_DEFAULT_LOGGER.info "----------"

      xml_to_parse = agent.post( quiz_post_uri, query_to_post )
      RAILS_DEFAULT_LOGGER.info "----------"
      RAILS_DEFAULT_LOGGER.info xml_to_parse.content
      RAILS_DEFAULT_LOGGER.info "----------"
      #otherwise, get the first page of data from the quiz API

      #turn it into something useful for display
      @xml = Nokogiri::XML( xml_to_parse.content )
      if @xml.xpath( "/quiz_request/completed_quiz_result" ).size > 0
        render :update do |page|
          page.redirect_to "/quizzes/#{@quiz.id}/result"
        end        
      else
        # hack in next page for now
        p = @xml.xpath( "/quiz_request/quiz_phase/position" )[ 0 ].content
        render :update do |page|
          page.redirect_to "/quizzes/#{@quiz.id}/#{p}"
        end
      end
    end
  end

  def result
    @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"
    quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/#{session[ :quiz_instance_uuid ]}/#{params[ :position ]}?format=xml"
    xml_to_parse = @agent.get( quiz_post_uri )
    @result_xml = Nokogiri::XML( xml_to_parse.content )

    partner_site = ::PartnerSite.find(:first, :conditions => {:domain => request.domain(1), :host => request.subdomains(1).first, :deleted_at => nil})
    if partner_site.nil?
      flash[:notice] = "Sorry page does not exist"
      render :action => :index and return
    end
    session[:quizzila_url] = "http://#{partner_site.host}.quizilla.#{partner_site.domain}#{ENV[ 'qport' ]}/quizzes?facebook_quiz=1"

    @options[ :url ] = "#{session[:quizzila_url]}"
    @catalog_request = @agent.get( @options )
    @catalog_xml = Nokogiri::XML( @catalog_request.body )
  end

  def quiz_offers
    @facebook_quiz = FacebookQuiz.find(params[:facebook_quiz_id])
    render :layout => false
  end

  private

  def create_http_agent
    logger.info "load http agent"
    @agent = Mechanize.new
    @options = {}
  end

  def load_quiz
    if params[ :id ]
      @partner_site = ::PartnerSite.find(:first, :conditions => {:domain => request.domain(1), :host => request.subdomains(1).first, :deleted_at => nil})
      # Grab the appropriate quiz, ensuring that it is available to this partner_site
      @quiz = Quiz.first(:joins => :shared_quizzes, :conditions => ["quizzes.id = ? and shared_quizzes.partner_site_id = ?", params[:id], @partner_site.id])
      return @quiz
    end
  end

end
