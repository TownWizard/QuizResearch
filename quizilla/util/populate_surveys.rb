UserQuizAnswer.delete_all
QuizInstance.delete_all
Survey.delete_all
SurveyTemplate.delete_all 

SurveyTemplate.create(:template_code => '<h2>Template A code header</h2><hr />{{survey}}<hr /><h2>Template A code footer</h2>', :deleted_at => nil)
SurveyTemplate.create(:template_code => '<h2>Template B code header</h2><hr />{{survey}}<hr /><h2>Template B code footer</h2>', :deleted_at => nil)
SurveyTemplate.create(:template_code => '<h2>Template C code header</h2><hr />{{survey}}<hr /><h2>Template C code footer</h2>', :deleted_at => nil)

template_ids = SurveyTemplate.find(:all).collect {|t| t.id}

10.times do |s|
  t = template_ids[rand(template_ids.size)]
  ri = 'Thanks! interstitial for template '.concat( t.to_s )
  st = SurveyTemplate.find_by_id(t).template_code.concat( t.to_s )
  
  
  Survey.create(
     :survey_template_id => t,
     :survey_display_instance => st,
     :quiz_id => 1,
     :partner_site_id => 1,
     :deleted_at => nil,
     :reward_interstitial => ri,
     :reward_url => 'http://www.thankyou.com'
  )
  
end