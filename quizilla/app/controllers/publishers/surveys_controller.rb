class Publishers::SurveysController < Publishers::BaseController
  layout 'publishers', :except => [ :edit, :new ]
  skip_before_filter :verify_authenticity_token
  before_filter :authorize_site_admin_access
  
  def create
    @survey = Survey.create params[ :survey ]
    @survey.survey_display_instance =  "<h2>Template A code header</h2><hr />{{survey}}<hr /><h2>Template A code footer</h2>13"
    @survey.survey_template_id = SurveyTemplate.find(:first).id
    @survey.partner_site_id = session[:partner_site_id].to_i
    @survey.save!
    respond_to do |wants|
      wants.html { redirect_to "/publishers/surveys/show/#{@survey.id}" and return }
    end
  end

  def destroy
    Survey.destroy( params[ :id ] )
    flash[ :notice ] = "Survey Deleted."
    redirect_to "/publishers/surveys" and return
  end

  def edit
    @survey = Survey.find params[ :id ]
    @quizzes = Quiz.all(
      :conditions => [ 'partner_site_id = ?', session[:partner_site_id].to_i ],
      :joins => { :shared_quizzes => :partner_site } )
  end

  def index
    @surveys = Survey.all(
      :conditions => [ 'partner_site_id = ?', session[:partner_site_id].to_i ])
  end
  
  def new
    @survey = Survey.new
    @quizzes = Quiz.all(
      :conditions => [ 'partner_site_id = ?', session[:partner_site_id].to_i ],
      :joins => { :shared_quizzes => :partner_site } )
  end

  def update
    @survey = Survey.find params[ :id ]
    @survey.update_attributes( params[ :survey ])
    flash[ :notice ] = "You successfully updated your survey."
    redirect_to "/publishers/surveys/show/#{params[ :id ]}" and return
  end

  def show
    @survey = Survey.find( params[ :id ] )
  end

end
