SharedQuiz.delete_all

quiz_ids = Quiz.find(:all, :conditions => "active=1").collect {|quiz| quiz.id}
partner_site_ids = PartnerSite.find(:all).collect {|ps| ps.id}

10.times do |s|
  q = quiz_ids[rand(quiz_ids.size)]
  ps = partner_site_ids[rand(partner_site_ids.size)]
  SharedQuiz.create(:quiz_id => q, :partner_site_id => ps, :deleted_at => nil)
  
end