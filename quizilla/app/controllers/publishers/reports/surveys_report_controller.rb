class Publishers::Reports::SurveysReportController < Publishers::BaseController

  layout 'publishers'

  def index
    if session[ :partner_site_id ]
#      @partner = PartnerSite.find( session[ :partner_site_id ] ).partner
      if current_user.has_role? 'admin'
        @partner_surveys = Survey.find(:all)
      elsif current_user.has_role? 'partner_site_report_viewer'
        @partner_surveys = Survey.find(
          :all,
          :conditions => [ "partner_site_id = ?", current_user.partner_site.id ]
        )
      else
        @partner_surveys = Survey.find(
          :all,
          :conditions => [ "partners.id = ?", current_user.partner.id ],
          :joins => { :partner_site => :partner }
        )
      end

      @partner_surveys.each do |survey|

        survey[ :open_count ] = QuizInstance.count(
          :conditions => [ "surveys.id = ?", survey.id ],
          :joins => { :quiz => :surveys }
        )

        survey[ :completed_count ] = QuizInstance.count(
          :conditions => [ "surveys.id = ? and completed = ?", survey.id, true ],
          :joins => { :quiz => :surveys }
        )

      end
    end
  end

  def show
    current_survey = Survey.find( params[ :id ] )

    @table = UserQuizAnswer.report_table(
      :all,
      :conditions => [
        'surveys.id = ? and quiz_instances.quiz_id = ? and quiz_instances.completed = ? and quiz_questions.active = ? and quiz_phases.active = ?',
        params[ :id ], current_survey.quiz_id, true, true, true ],
      :joins => [ :quiz_instance, { :quiz_answer => { :quiz_question => { :quiz_phase => :quiz } } }, { :quiz_instance => {:quiz => :surveys}} ],
      :include => { :quiz_answer => { :only => [ :id, :answer, :position ],
        :include => { :quiz_question => { :only => [ :id, :question, :active ],
          :include => { :quiz_phase => { :only => [ :position ] } } } }
        }
      }
    )

    @unsorted_quiz_question_grouping = Grouping(
      @table,
      :by => [ 'quiz_question.id', 'quiz_answer_id' ]
    )


    @quiz_question_grouping = @unsorted_quiz_question_grouping.sort_grouping_by { |g| g.column "quiz_phase.position" }

    if params[ :chart_type ] == 'column'
      render :template => 'publishers/reports/surveys_report/column'
    else
      render :template => 'publishers/reports/surveys_report/pie'
    end
  end
end
