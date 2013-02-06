class SuggestionObserver < ActiveRecord::Observer
  #after_create :email_em
  
  def after_create
    SuggestMailer.deliver_suggest_quiz
  end
end
