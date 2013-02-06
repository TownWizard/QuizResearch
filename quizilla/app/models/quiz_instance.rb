class QuizInstance < ActiveRecord::Base
  unloadable
  belongs_to :quiz
  belongs_to :user
  has_many :user_quiz_answers

  acts_as_reportable
  
  named_scope( :current, lambda do |qiid| {
    :include => :user_quiz_answers, :conditions => [ 'quiz_instance_uuid = ?', qiid ]
  }
    end
  )

  named_scope :completed, :conditions => [ 'completed = ?', true ]
  named_scope :incomplete, :conditions => [ 'completed != ?', true ]
  
  @@uuid_generator = UUID.new

  # OPTIMIZE [gmc] moving this into pure sql, maybe via named scope, is a 
  # potential optimize candidate when the question count grows to full size.
  def answers_for_phase( phase_id )
    @user_quiz_answers ||= self.user_quiz_answers#( :include => { :quiz_learning_blurbs => affiliate_products } )
    @user_quiz_answers.select { |uqa| uqa.quiz_answer.quiz_question.quiz_phase_id == phase_id }
  end

  def answers_for_page( position )
    @user_quiz_answers ||= self.user_quiz_answers#( :include => { :quiz_learning_blurbs => affiliate_products } )
    @user_quiz_answers.select { |uqa| uqa.quiz_answer.quiz_question.quiz_phase.position == position }
  end
  # determines if a quiz instance is completed.  Completed is defined as having
  # a number of answers uqual to the total number of questions.  Has the side effect
  # of completing the quiz if the current completed value is false.  
  def completed?
    if self.completed == true
      true
    end

    if( self.user_quiz_answers.count == self.quiz.quiz_phases.collect{ |p| p.quiz_questions }.size )
      self.completed = true
      true
    else
      false
    end
  end

  def self.new_quiz_instance( user, quiz_id, survey_id, qiid = nil, lqa_id = nil )
    if user
      user_id = user.id
    else
      user_id = nil
    end
    
    if qiid
      begin
        
        QuizInstance.create(
          :quiz_id => quiz_id,
          :user_id => user_id,
          :quiz_instance_uuid => qiid,
          :survey_id => survey_id,
          :lead_answer_id => lqa_id )

      rescue ActiveRecord::StatementInvalid
        # sigh.  we probably tripped the duplicate key exception for this user.
        # look for any other incomplete instances to load up.
        qi = QuizInstance.find( :first, :conditions => [ 'user_id = ? and quiz_id = ? and survey_id = ?', user_id, @id, survey_id ] )

      end
    else
      if user
        # check for incomplete instances (of thiz quiz ) from this user
        qi = QuizInstance.find( :first, :conditions => [ 'user_id = ? and quiz_id = ? and survey_id = ?', user_id, @id, survey_id ] )
        if qi == nil
          QuizInstance.create( 
            :quiz_id => quiz_id,
            :user_id => user_id,
            :quiz_instance_uuid => @@uuid_generator.generate( :compact ),
            :survey_id => survey_id,
            :lead_answer_id => lqa_id )
        else
          qi
        end
      else
        QuizInstance.create(
          :quiz_id => quiz_id,
          :user_id => user_id,
          :quiz_instance_uuid => @@uuid_generator.generate( :compact ),
          :survey_id => survey_id,
          :lead_answer_id => lqa_id )
      end
    end
  end

end
