require 'uri'
require 'net/http'
require 'open-uri'
require 'xml'
require 'mechanize'
require 'liquid'

class SurveysController < ApplicationController
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

  before_filter :load_survey
  
  def show
    
    #sniff the url to determine our survey id
    if params[ :id ]

      p "@@@@@@@@@@@@@@"
      p params[ :id ]
      p @partner_site

      #use the survey id to determine the quiz we want to display
      @survey = Survey.find( :first, :conditions => ["id = ? AND partner_site_id = ?", params[:id], @partner_site.id] )
      p "@@@@@@@@@@@@@@@"
      p @survey
      if @survey
        #Grab the appropriate quiz, ensuring that it is available to this partner_site
        @quiz = Quiz.first( :joins => :shared_quizzes, :conditions => [ "quizzes.id = ? and shared_quizzes.partner_site_id = ?", @survey.quiz_id, @partner_site.id ] )

        if @quiz
          #build useful URLS.  base_uri needs to be available to the view as well
          @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"

          if params[ :position ]
            quiz_request_uri = "#{ENV[ 'qport' ]}/quizzes/open/#{session[ :quiz_instance_uuid ]}/#{params[ :position ]}/?format=xml&survey_id=#{@survey.id}"
          else
            if @quiz.lead_phase.nil?
              @quiz_instance = QuizInstance.create(
                :quiz_id => @quiz.id,
                :user_id => nil,
                :quiz_instance_uuid => @@uuid_generator.generate( :compact ),
                :lead_answer_id => nil,
                :partner_user_id => params[ :user_id ]
              )
              session[:quiz_instance_uuid] = @quiz_instance.quiz_instance_uuid
              if session[ :survey_instance_id ]
                si = SurveyInstance.find( session[ :survey_instance_id ] )
                si.quiz_instance_uuid = session[:quiz_instance_uuid]
                si.save
              end
              redirect_to "/surveys/#{params[ :id ]}/1", :status => 303 and return
            end
            quiz_request_uri = "#{ENV[ 'qport' ]}/quizzes/" << @survey.quiz_id.to_s << "?format=xml&survey_id=#{@survey.id}"
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

          if @xml.xpath( "/errors" ).size > 0
            @xml.xpath( "/errors//friendly_message" ).each do |e|
              @errors = e
            end
            # map errors
            #render :text => "error case"
          end
        end
      end
    end
  end

  def new
    #if params[ :user ] && params[ :user ][ :email ] && params[ :id ]
    #  if params[ :user ][ :email ] =~ EmailAddress
    if params[ :questions ]
      #          u = User.new :email => params[ :user ][ :email ]
      #          u.update_attribute( :partner_site_id, params[ :partner_site_id ] )
      #          u.save( false )
      #          session[ :user_id ] = u.id

      @base_request_uri = "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}"
      # now make a quiz_instance
      quiz_post_uri = "#{@base_request_uri}#{ENV[ 'qport' ]}/quizzes/open/new?format=xml&survey_id=#{@survey.id}"

      agent = Mechanize.new
      agent.basic_auth 'demouser', 'demopass'

      t_params = params.except( :controller, :action )

      #seed query with new user id
      query_to_post = { :user_id => "survey_user" }

      # this is here because Mechanize used to mangle params in the past.  Not sure if it still does.
      t_params.each_pair do |k,v|
        if k == "questions"

          v.each_pair do |x,y|
            query_to_post[ "questions[#{x}]" ] = y.collect {|a| a }.join ','
          end
        elsif k == "answer"
          v.each_pair do |x,y|
            query_to_post[ "answer[#{x}]" ]=y
          end
        elsif k == "lqa"

          v.each_pair do |x,y|
            query_to_post[ "lqa[#{x}]" ] = y
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

      @xml = Nokogiri::XML( xml_to_parse.content )

      if @xml.xpath( "/errors" ).size > 0
        #            flash[ :email ] = params[ :user ][ :email ]
        #            flash[ :errors ] = []

        # lets map these errors over to something more friendly for the user.
        # Trying to think of a good way to do this. for now, let's use a
        # comboe of field / code.

        @xml.xpath( "/errors//error" ).each do |e|
          flash[ :errors ] << map_errors( e )
        end

        # collect submitted answers for inclusion in flash.
        #collect submitted answers for inclusion in flash
        flash[ :free_text_answers ] = Hash.new
        if params[ :lqa ]
          flash[ :submitted_answers ] = params[ :lqa ].collect { |q,v| v }.join ','
          flash[ :free_text_answers ]=params[ :answer ]
        end

        redirect_to :back and return
      end

      quiz_instance_uuid = @xml.xpath( "/quiz_request/quiz_request_metadata/quiz_instance_uuid" )
      if quiz_instance_uuid.size > 0
        session[ :quiz_instance_uuid ] = quiz_instance_uuid[ 0 ].content
        if session[ :survey_instance_id ]
          si = SurveyInstance.find( session[ :survey_instance_id ] )
          si.quiz_instance_uuid = quiz_instance_uuid[ 0 ].content
          si.save
        end
      end
      position = @xml.xpath( "/quiz_request/quiz_phase/position" )[0].content
      redirect_to "/surveys/#{params[:id]}/#{position}", :status => 303 and return
    else

      flash[ :errors ] = "Please answer all questions to continue."
      redirect_to :back and return

    end
    #      else
    #        flash[ :errors ] = "Please supply a valid email address to continue."
    #        # collect submitted answers for inclusion in flash.
    #        if params[ :lqa ]
    #          flash[ :submitted_answers ] = params[ :lqa ].collect { |q,v| v }.join ','
    #        end
    #        redirect_to :back
    #        #redirect_to "/surveys/#{params[:survey_id ]}" and return
    #      end

    #    else
    #      flash[ :errors ] = "Please supply a valid email address to continue."
    #      redirect_to :back
    ##      @errors = [
    ##        'Must supply email address and survey id to continue',
    ##        'Please enter an email address to continue.',
    ##        400
    ##      ]
    #    end
  end


  def submit_answers

    #sniff the url to determine our survey id
    if params[ :id ]

      #use the survey id to determine the quiz we want to display
      @survey = Survey.find( :first, :conditions => ["id = ? AND partner_site_id = ?", params[:id], @partner_site.id] )

      if @survey
        #Grab the appropriate quiz, ensuring that it is available to this partner_site
        @quiz = Quiz.first( :joins => :shared_quizzes, :conditions => [ "quizzes.id = ? and shared_quizzes.partner_site_id = ?", @survey.quiz_id, @partner_site.id ] )

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
              reset_session
              render :registration_complete, :layout => false
#              if @survey.id >= 32
#                reset_session
#                if @survey.id == 46 || @survey.id == 47 || @survey.id == 48 || @survey.id == 49
##                  redirect_to @survey.reward_url and return
#                  render :registration_complete, :layout => false
#                else
#                  render :registration_complete, :layout => false
#                end
#              else
#                render 'registration'
#              end
            else
              # hack in next page for now
              p = @xml.xpath( "/quiz_request/quiz_phase/position" )[ 0 ].content
              redirect_to "/surveys/#{@survey.id}/#{p}"
            end

          end
        else
          head 404
        end
      else
        head 404
      end

    else
      head 404
    end

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