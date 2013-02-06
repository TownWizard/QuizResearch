require 'mechanize'

class QuizzesController < ApplicationController
  before_filter :create_http_agent
  before_filter :load_quiz

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

  @@uuid_generator = UUID.new

  def start
    p '@@@@@@@@@@@@@@@@@@'
    if @quiz
      # First create quiz instance before starting a quiz as lead phase is not going to be displayed
      @quiz_instance = QuizInstance.create(
        :quiz_id => @quiz.id,
        :quiz_instance_uuid => @@uuid_generator.generate( :compact ),
        :partner_site_id => @partner_site.id
      )
      session[:quiz_instance_uuid] = @quiz_instance.quiz_instance_uuid      
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

    #sniff the url to determine our survey id
    if params[ :id ]
        if @quiz

          #build useful URLS.  base_uri needs to be available to the view as well
          @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"

          #quiz_post_uri = "http://#{@partner_site.host}.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml&amp;survey_id=#{@survey.id}"
          quiz_post_uri = ""

          if params[ :position ]
            quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/#{session[ :quiz_instance_uuid ]}/#{params[ :position ]}?format=xml"
          else
            quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml&survey_id=#{@survey.id}"
          end

          #create a new instance of mechanize to gather the xml for us
          agent = Mechanize.new
          agent.basic_auth 'demouser', 'demopass'
          #collect the quiz xml

          # mechanize munges nested hashes in params, so we have to set up a new
          # param hash.
          t_params = params.except( :controller, :action )

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

          if @xml.xpath( "/errors" ).size > 0
            flash[ :errors ] = []
            @xml.xpath( "/errors/error" ).each do |e|
              flash[ :errors ] << map_errors( e )
            end

            #collect submitted answers for inclusion in flash
            flash[ :free_text_answers ] = Hash.new

            if params[ :questions ]
              flash[ :submitted_answers ] = params[ :questions ].collect { |q,v| v }.join ','
              flash[ :free_text_answers ]=params[ :answer ]

            end

            redirect_to :back and return
          else

            if @xml.xpath( "/quiz_request/completed_quiz_result" ).size > 0
#              reset_session
              render :result, :layout => false
            else
              # hack in next page for now
              p = @xml.xpath( "/quiz_request/quiz_phase/position" )[ 0 ].content
              redirect_to "/quizzes/#{@quiz.id}/#{p}"
            end

          end
        else
          head 404
        end
      else
        head 404
      end
  end

#  def submit_answers
#
#
#    if @quiz
#      #build useful URLS.  base_uri needs to be available to the view as well
#      @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"
#
#      #quiz_post_uri = "http://#{@partner_site.host}.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml&amp;survey_id=#{@survey.id}"
#      quiz_post_uri = ""
#      if params[ :position ]
#        quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/#{session[ :quiz_instance_uuid ]}/#{params[ :position ]}?format=xml"
#      else
#        quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml"
#      end
#      unless params["questions"].nil?
#        params[:answer_id] = params["questions"].first[1].first.to_i
#
#        #create a new instance of mechanize to gather the xml for us
#        agent = Mechanize.new
#        agent.basic_auth 'demouser', 'demopass'
#        #collect the quiz xml
#
#        # mechanize munges nested hashes in params, so we have to set up a new
#        # param hash.
#        t_params = params.except( :controller, :action )
#
#        q = Hash["questions", Hash[params[:question_id], [params[:answer_id]]]]
#
#        t_params.delete("question_id")
#        t_params.delete("answer_id")
#
#        t_params = t_params.merge!(q)
#
#        query_to_post = {}
#        t_params.each_pair do |k,v|
#          if k == "questions"
#            v.each_pair do |x,y|
#              query_to_post[ "questions[#{x}]" ] = y.collect {|a| a }.join ','
#            end
#          elsif k == "answer"
#            v.each_pair do |x,y|
#              query_to_post[ "answer[#{x}]" ]=y
#            end
#          else
#            query_to_post[ k ] = v
#          end
#        end
#
#        RAILS_DEFAULT_LOGGER.info "----------"
#        RAILS_DEFAULT_LOGGER.info "Proxying submission to: #{quiz_post_uri}"
#        RAILS_DEFAULT_LOGGER.info "----------"
#
#        xml_to_parse = agent.post( quiz_post_uri, query_to_post )
#        RAILS_DEFAULT_LOGGER.info "----------"
#        RAILS_DEFAULT_LOGGER.info xml_to_parse.content
#        RAILS_DEFAULT_LOGGER.info "----------"
#        #otherwise, get the first page of data from the quiz API
#
#        #turn it into something useful for display
#        @xml = Nokogiri::XML( xml_to_parse.content )
#        if @xml.xpath( "/errors" ).size > 0
#          flash[:notice] = "Please complete all questions before continuing."
#          redirect_to "/quizzes/#{@quiz.id}/#{params[:position]}"
#        elsif @xml.xpath( "/quiz_request/completed_quiz_result" ).size > 0
#          render :result, :layout => false
#        else
#          # hack in next page for now
#          p = @xml.xpath( "/quiz_request/quiz_phase/position" )[ 0 ].content
#          redirect_to "/quizzes/#{@quiz.id}/#{p}"
#        end
#      else
#        flash[:notice] = "Please select an answer to move forward"
#        redirect_to "/quizzes/#{@quiz.id}/#{params[:position]}"
#      end
#    end
#  end

  def result
    
  end

  

  private

  def create_http_agent
    logger.info "load http agent"
    @agent = Mechanize.new
    @agent.basic_auth 'demouser', 'demopass'
    @options = {}
  end

  def load_quiz
    if params[ :id ]
      session[:widget_id] = params[:widget_id] if params[:widget_id]
      @widget = Widget.find session[:widget_id]
      
      @partner_site = ::PartnerSite.find(:first, :conditions => {:domain => request.domain(1), :host => request.subdomains(1).first, :deleted_at => nil})
      # Grab the appropriate quiz, ensuring that it is available to this partner_site
      @quiz = Quiz.first(:joins => :shared_quizzes, :conditions => ["quizzes.id = ? and shared_quizzes.partner_site_id = ?", params[:id], @partner_site.id])
      return @quiz
    end
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
