
Sham.define do
  Sham.label { Faker::Lorem.sentence }
  Sham.text { Faker::Lorem.paragraphs }
  Sham.position { |index| "#{index}" }
end

Quiz.blueprint do
  #QuizCategory
  name { Sham.label }
  description { Sham.text }
end

QuizCategory.blueprint do
  name { Sham.label }
end

QuizPhase.blueprint do
  quiz Quiz.make
  name { Sham.label }
  #position Sham.position
end