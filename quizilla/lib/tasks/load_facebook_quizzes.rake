require "active_record/fixtures"
namespace :db do
  task :load_facebook_quizzes => :environment do
    quiz_list = ["get_a_guy", "victoria_secret", "social_media", "drill_sergeant_or_pushover",
      "relationship_healthy", "ready_for_baby", "work_run_your_life", "dying_to_be_beautiful", 
      "disney_princess", "shopaholic", "you_handle_fame", "sports_fan", "tv_mom",
      "approach_to_dating", "travel_next", "happy_are_you", "healthy_your_body"
      ]

    quiz_list.each do |quiz_name|
      # Load a yaml file for a current quiz first
      yaml = YAML::load(File.open("#{RAILS_ROOT}/lib/facebook_quizzes/#{quiz_name}.yml"))
      puts "Importing quiz--- \"#{yaml['quiz']['name']}\""

      # Extract +quiz_phases+ hash from quiz
      phases_y = yaml["quiz"].delete("quiz_phases").sorted_hashes
      # Extract +quiz_recommendations+ hash from quiz
      recommendations_y = yaml["quiz"].delete("quiz_recommendations")
      # Extract +facebook_quiz+ hash from quiz
      facebook_quiz_y = yaml["quiz"].delete("facebook_quiz")
      quiz_y = yaml["quiz"]

      # Check if quiz has already created or not. Skip it if created and continue with next
      unless Quiz.find_by_name(quiz_y["name"]).nil?
        puts "Already exist!!! Skipping..."
        next
      else
        puts "....."
      end

      # Create a quiz using quiz yaml data
      quiz = Quiz.create(quiz_y)
      # Based on created quiz, create +facebook_quizzes+ record to mark it as a facebook quiz for a partner site
      FacebookQuiz.create(facebook_quiz_y.merge!(:quiz_id => quiz.id))
      # Based on created quiz, create all the quiz recommendations using +quiz_recommendations+ yaml data
      recommendations_y.each do |rec|
        quiz.quiz_recommendations.create(rec[1])
      end

      # Loop through each quiz_phases yaml data set to extract quiz questions, answers and create them
      phases_y.each do |phase_y|
        # Extract +quiz_questions+ hash from current quiz_phase yaml        
        questions_y = phase_y[1].delete("quiz_questions")
        # Based on created quiz, create the quiz phase using current +quiz_phases+ yaml data
        phase = quiz.quiz_phases.create(phase_y[1])
     
        # Loop through each +quiz_questions+ yaml data set to extract quiz answers and create them
        questions_y.each do |que_y|
          # Extract +quiz_answers+ hash from current quiz_question yaml
          answers_y = que_y[1].delete("quiz_answers")
          # Based on created quiz_phase, create a +quiz_question+ and assign to that phase
          question = phase.quiz_questions.create(que_y[1])

          # Loop through each +quiz_answers+ yaml data set to create each
          answers_y.each do |ans_y|
            # Based on created quiz_question, create a +quiz_answer+ and assign to that question
            ans = question.quiz_answers.create(ans_y[1])
            # Create a blank learning blurb for current quiz answer created
            QuizLearningBlurb.create(:quiz_answer_id => ans.id)
          end unless answers_y.nil?
        end unless questions_y.nil?
      end unless phases_y.nil?

    end
  end
end
