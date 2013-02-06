class FacebookInstance < ActiveRecord::Base
  belongs_to :user
  belongs_to :facebook_quiz
end
