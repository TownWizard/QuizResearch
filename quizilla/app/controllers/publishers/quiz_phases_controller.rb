class Publishers::QuizPhasesController < Publishers::BaseController
  #layout 'publishers'
  before_filter :authorize_site_admin_access
  
  def create
    p = QuizPhase.create params[ :quiz_phase ]
    #p.insert_at params[ :position ]
    pos = p.position
    respond_to do |wants|
      #wants.html { publishers_redirect "phase-#{pos}" and return }
      wants.html { redirect_to "/publishers/quizzes/show/#{params[ :quiz_phase ][ :quiz_id ]}#phase-#{pos}" and return }
    end
  end

  def destroy
    quiz_id = QuizPhase.find( params[ :id ]).quiz.id
    QuizPhase.destroy( params[ :id ] )
    flash[ :notice ] = "Quiz Phase Deleted."
    @quiz_phases_list = "Enabled"
    redirect_to "/publishers/quizzes/#{quiz_id}" and return
  end
  
  def edit
    @quiz_phase = QuizPhase.find params[ :id ]
  end

  def new
    @quiz_phase = QuizPhase.new
    @default_position = QuizPhase.count( :position, :conditions => "quiz_id=#{params[ :quiz_id ]}" )
  end

  def show
    @quiz_phase = QuizPhase.find params[ :id ]
  end

  def update
    @quiz_phase = QuizPhase.find params[ :id ]
    @quiz_phase.update_attributes params[ :quiz_phase ]
    quiz_id = @quiz_phase.quiz_id
    flash[ :notice ] = "Quiz Phase Edited."
    redirect_to "/publishers/quizzes/show/#{quiz_id}#phase-#{@quiz_phase.position}"
   # redirect_to "/publishers/quizzes/show/#{quiz_id}?quiz_phases_list=enabled#phase-#{@quiz_phase.position}"
  end

end
