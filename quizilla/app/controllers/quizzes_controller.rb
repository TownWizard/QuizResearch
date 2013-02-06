class QuizzesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_request, :load_user, :expose_authenticity_token, :set_version_string

  layout 'quizzes', :except => :test_create
  
  # selects random quiz based on parter site category identifier.
  def get_by_partner_category
    if params[ :category_identifier ]
      @partner_category = PartnerSiteCategory.first :conditions => [
          'name = ? and partner_site_id = ?',
          params[ :category_identifier ],
          @partner_site.id ]

      @quiz = Quiz.find( :first, :order => 'RAND()', 
        :conditions =>
          "active=1 and quiz_category_id IN ( #{@partner_category.quiz_categories.collect { |qc| qc.id }.join( ',' )} )
          AND id IN ( #{@partner_site.shared_quizzes.collect{ |sq| sq.id }.join( ',' )})"
      )
      
      if @quiz
        @quiz_phase = @quiz.quiz_phases.first

        render 'show'
        #render :xml => @quiz.to_xml
      else
        head 404
      end
    else
      render 400
    end
  end

  def get_by_category_and_user
    require 'mechanize'
    agent = WWW::Mechanize.new
    page = agent.get( 'http://localhost:3001/quizzes/1' )
    
    render :text => page.to_s
  end

  def index
    # It identifies if request is not xml and URL is 'http://publisher.quizresearch.com', then it redirects to publishers section
    # And displays publishers home/login page to users.
    # Such a way, publisher site always run on 'http://publisher.quizresearch.com' URL.
    if params[:format].nil?
      redirect_to publishers_url and return if request.server_name.eql?("publisher.quizresearch.com")
    end
    if params[ :category_identifier ]
      #@quizzes = Quiz.find( :all, :conditions => { :active => true } )
      @quizzes  = Quiz.all( :conditions =>
        [ "quizzes.active=1 and partner_site_id = ? AND partner_site_categories.name = ?",
        @partner_site.id,
        params[ :category_identifier ] ],
      :joins => { :quiz_category => :partner_site_categories } )
    elsif params[:facebook_quiz] == "1"
      @quizzes  = Quiz.all( :conditions => ["quizzes.active=1 AND partner_site_id = ? AND is_active=1", @partner_site.id ],
        :joins => :facebook_quizzes,
        :include => [ { :quiz_category => :partner_site_categories } ] )
    else
      @quizzes  = Quiz.all( :conditions =>
        [ "quizzes.active=1 AND partner_site_id = ?",
        @partner_site.id ],
      :joins => :shared_quizzes,
      :include => [  { :quiz_category => :partner_site_categories } ] )
    end

    cookied_quiz_instances = qiid_cookie_read

    if @user
      # fish out their completed quizzes and add them to the list.
      cookied_quiz_instances.concat( @user.quiz_instances.collect { |qi| qi.quiz_instance_uuid } )
      cookied_quiz_instances.uniq!
    end

    @quiz_instances = QuizInstance.find :all,
        :conditions => [ 'quiz_instance_uuid IN ( ? )', cookied_quiz_instances ]

    @quizzes.each do |quiz|
      quiz[ :total_quiz_questions ] = QuizQuestion.count(
        #:conditions => [ 'quizzes.id = ? and quiz_questions.active = 1 and quiz_phases.position > 0', @quiz_instance.quiz.id ],
        :conditions => [ 'quizzes.id = ? and quiz_questions.active = 1', quiz.id ],
        :joins => { :quiz_phase => :quiz }
      )
    end
    #respond_to do |wants|
    #  wants.html { render 'index.html' }
    #  wants.xml { render :file => 'quizzes/index.xml', :layout => 'quizzes' }
    #end
    render :file => 'quizzes/index.xml', :layout => 'quizzes'
  end
  
  # moved a lot of the duplicate resolution logic here.
  # if someone has an instance of this quiz cookied but not completed, we'll
  # want to make sure they don't start it twice.
  def show
    saved_instances = qiid_cookie_read
    if @user
      saved_instances << @user.quiz_instances.collect { |qi| qi.quiz_instance_uuid }
    end
    saved_instances.uniq!

    @token = self.form_authenticity_token
    @quiz_page = 1
    @quiz = Quiz.find params[ :id ]
    
    if @quiz
      @lead_question = @quiz.lead_phase.quiz_questions.first
      @quiz_phase = @quiz.quiz_phases.first
      render 'quizzes/show'
      #render :file => 'quizzes/show.xml'
      #render :xml => @quiz.to_xml
    else
      head 404
    end
    
  end

  def test_create
    
  end

end
