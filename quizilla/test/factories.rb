
Factory.define :quiz_learning_blurb do |qlb|
  qlb.name Sham.label
  qlb.blurb Sham.text
end

Factory.define :quiz_answer do |qa|
  qa.answer Sham.label
  qa.quiz_learning_blurb Factory( :quiz_learning_blurb )
end

Factory.define :quiz_category do |qc|
  qc.name Sham.label
end

Factory.define :quiz do |q|
  q.name Sham.label
  q.association :quiz_category, :factory => :quiz_category
  q.quiz_phases do |phase|
    assoc = []
    3.times do
      assoc << Factory( :quiz_phase )
    end
    assoc
  end
end

Factory.define :quiz_phase do |qp|
  qp.name Sham.label
  qp.position Sham.position
  qp.quiz_questions do |question|
    assoc = []
    3.times do
      assoc << Factory( :quiz_question, :position => Sham.position )
    end
    assoc
  end
end

Factory.define :quiz_question do |qq|
  qq.question Sham.label
  qq.position Sham.position
  qq.quiz_answers do |answer|
    assoc = []
    3.times do
      assoc << Factory( :quiz_answer, :position => Sham.position )
    end
    assoc
  end
end

Factory.define :user do |u|
  u.login Sham.email
  u.password 'my_password'
  u.password_confirmation 'my_password'
  u.email Sham.email
  u.name_first Faker::Name.first_name
  u.name_last Faker::Name.last_name
  u.dob_confirmed 1
end

#/Factory.define :quiz_instance do |qi|
#  qi.quiz Factory :quiz
#end

