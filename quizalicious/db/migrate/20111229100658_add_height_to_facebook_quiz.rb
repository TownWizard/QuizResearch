class AddHeightToFacebookQuiz < ActiveRecord::Migration
  def self.up
    add_column :facebook_quizzes, :height, :integer, :default => 1000
  end

  def self.down
    remove_column :facebook_quizzes, :height
  end
end
