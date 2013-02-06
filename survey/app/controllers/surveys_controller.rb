require 'uri'
require 'net/http'
require 'open-uri'
require 'xml'
require 'mechanize'
require 'liquid'

class SurveysController < ApplicationController
  EmailAddress = begin
    qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
    dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
    atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
      '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
    quoted_pair = '\\x5c[\\x00-\\x7f]'
    domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
    quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
    domain_ref = atom
    sub_domain = "(?:#{domain_ref}|#{domain_literal})"
    word = "(?:#{atom}|#{quoted_string})"
    domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
    local_part = "#{word}(?:\\x2e#{word})*"
    addr_spec = "#{local_part}\\x40#{domain}"
    pattern = /\A#{addr_spec}\z/
  end

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

  before_filter :load_survey, :load_user#, :expose_authenticity_token
  # index method
  def index
    survey_list = {"synapse" => 31, "dressbarn" => 32, "petco" => 33, "generic" => 34, "signaturehomestyles" => 35,
      "pamperedchef" => 36, "tomboytools" => 37, "redrobin" => 38, "twe" => 39, "marykay" => 40, "jafra" => 41, "scentsy" => 42,
      "fbm" => 43, "fbmibd" => 44, "avon" => 45, "amfam" => 46, "fbm2" => 47, "massmarkold" => 48, "massmark" => 49
    }

    @survey = Survey.find( :first, :conditions => ["id = ? AND partner_site_id = ?", survey_list[params[:path].first], @partner_site.id] )

    if @survey
      #Grab the appropriate quiz, ensuring that it is available to this partner_site
      @quiz = Quiz.first( :joins => :shared_quizzes, :conditions => [ "quizzes.id = ? and shared_quizzes.partner_site_id = ?", @survey.quiz_id, @partner_site.id ] )
      #debugger
      if @quiz && (request.server_name == "#{@partner_site.host}.quizilla.#{@partner_site.domain}" || request.server_name == "#{@partner_site.host}.survey.#{@partner_site.domain}")
      else
        #head 404
        render 'unavailable' and return
      end
    end

    session[ :survey_id ] = nil if session[ :survey_id ]
    render :action => params[:path]
  rescue
    render :action => "unavailable"
  end

  # THIS IS TEMPORARY, AND SHOULD BE REMOVED OR REPLACED WITH ACTUAL
  # FUNCTIONALITY POST DEMO
  def synapse
    @survey = Survey.find_by_id( 31 )
    skip_landing_page_if_not_configured
  end

  def dressbarn
    @survey = Survey.find_by_id( 32 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def petco
    @survey = Survey.find_by_id( 33 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def generic
    @survey = Survey.find_by_id( 34 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def signatureHomestyle
    @survey = Survey.find_by_id( 35 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def pamperedChef
    @survey = Survey.find_by_id( 36 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def tomboyTools
    @survey = Survey.find_by_id( 37 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def redrobin
    @survey = Survey.find_by_id( 38 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def twe
    @survey = Survey.find_by_id( 39 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def marykay
    @survey = Survey.find_by_id( 40 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def jafra
    @survey = Survey.find_by_id( 41 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def scentsy
    @survey = Survey.find_by_id( 42 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def fbm
    @survey = Survey.find_by_id( 43 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def fbm2
    @survey = Survey.find_by_id( 47 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def fbmibd
    @survey = Survey.find_by_id( 44 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def avon
    @survey = Survey.find_by_id( 45 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def massmarkold
    @survey = Survey.find_by_id( 48 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def massmark
    @survey = Survey.find_by_id( 49 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
  end

  def unavailable

  end

  def amfam
    @survey = Survey.find_by_id( 46 )
    if session[ :survey_id ]
      session[ :survey_id ] = nil
    end
    skip_landing_page_if_not_configured
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

  def register
    if(
        params[ :user ] && (
          params[ :user ][ :name_first ] && params[ :user ][ :name_first ] != "" &&
            params[ :user ][ :name_last ] && params[ :user ][ :name_last ] != "" &&
            params[ :user ][ :email ] && params[ :user ][ :email ] != "" ) )

      @survey = Survey.find( params[ :id ] )
      params[ :user ][ :login ] = "a_fake_login"
      params[ :user ][ :password ] = "a_fake_password"
      params[ :user ][ :password_confirmation ] = "a_fake_password"
      begin
        @user.update_attributes! params[ :user ]
      rescue
      end
      #if @user.save
      #flash[:notice] = "Account registered!"
      #      if cookies[ :lcqiid ] && cookies[ :lcqiid ] != ''
      #        redirect_to :controller => :assessments, :action => :get
      #      else
      #        redirect_to :controller => :assessments, :action => :index
      #      end
      reset_session
      render :registration_complete
      #else
      #  render :text => "fail!!"
      #end
    else
      flash[ :errors ] = "Please complete all required fields to claim your reward."

      flash[ :name_first ] = params[ :user ][ :name_first ]
      flash[ :name_last ] = params[ :user ][ :name_last ]
      flash[ :email ] = params[ :user ][ :email ]

      flash[ :addr1 ] = params[ :addr1 ]
      flash[ :addr2 ] = params[ :addr2 ]
      flash[ :city ] = params[ :city ]
      flash[ :state ] = params[ :state ]
      flash[ :zip ] = params[ :zip ]
      flash[ :dob_month ] = params[ :dob_month ]
      flash[ :dob_day ] = params[ :dob_day ]
      flash[ :dob_year ] = params[ :dob_year ]

      redirect_to "/surveys/registration/#{params[:id ]}" and return
    end
  end

  def registration

  end

  def show
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

 def start
    ## bhavan: changed to remove Omniauth, otherwize all surveys are going to twe

    #this is where you get all the data from your provider through omniauth
    #omniauth = request.env['rack.auth']
    #
    #if omniauth
    #  @si = SurveyInstance.create!(
    #    :customer_email =>  omniauth['extra']['user_hash']['email'],
    #    :name_first     =>  omniauth['user_info']['first_name'],
    #    :name_last      =>  omniauth['user_info']['last_name'],
    #    #        :city           =>  omniauth['extra']['user_hash']['hometown']['name'].split(',')[0],
    #    #        :state          =>  omniauth['extra']['user_hash']['hometown']['name'].split(',')[1],
    #    :gender         =>  omniauth['extra']['user_hash']['gender'],
    #    :uid            =>  omniauth['uid'],
    #    :provider       =>  omniauth['provider']
    #  )
    #  session[ :survey_instance_id ] = @si.id
    #  redirect_to "/surveys/39"
    #else
      @si = SurveyInstance.create!(
        :customer_email =>  params[ :user ][:email]
      )
      session[ :survey_instance_id ] = @si.id
      redirect_to "/surveys/#{@survey.id}"
    #end
    # we're good, so create the new survey instance to capture user information
  end

  def failure
    flash[:notice] = "Sorry, You din't authorize"
    redirect_to "/surveys/twe?message=#{params[:message]}"
  end

  def setup
    request.env['omniauth.strategy'].options = {:scope => "publish_stream, create_event, offline_access, manage_pages"}
    render :text => "Setup complete.", :status => 404
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
              if @survey.id >= 32
                reset_session
                if @survey.id == 46 || @survey.id == 47 || @survey.id == 48 || @survey.id == 49
                  redirect_to @survey.reward_url and return
                else
                  render :registration_complete
                end
              else
                render 'registration'
              end
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
  def load_survey
    if params[ :id ]
      #use the survey id to determine the quiz we want to display
      @survey = Survey.find( :first, :conditions => ["id = ? AND partner_site_id = ?", params[:id], @partner_site.id] )

      if @survey
        #Grab the appropriate quiz, ensuring that it is available to this partner_site
        @quiz = Quiz.first( :joins => :shared_quizzes, :conditions => [ "quizzes.id = ? and shared_quizzes.partner_site_id = ?", @survey.quiz_id, @partner_site.id ] )

        #debugger
        if @quiz && (request.server_name == "#{@partner_site.host}.quizilla.#{@partner_site.domain}" || request.server_name == "#{@partner_site.host}.survey.#{@partner_site.domain}")

        else
          #head 404
          render 'unavailable'
        end

      end
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

  def skip_landing_page_if_not_configured
    # If survey does not include landing page, then it should not be displayed
    # In this case, system will automatically create survey instance without any detail and
    # fill out the +quiz_instance_uuid+ once first question is answered
    unless @survey.has_landing_page
      si = SurveyInstance.create!()
      session[ :survey_instance_id ] = si.id
      redirect_to "/surveys/#{@survey.id}"
    end
  end

end
