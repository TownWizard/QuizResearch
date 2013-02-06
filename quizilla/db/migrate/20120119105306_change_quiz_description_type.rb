class ChangeQuizDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :quizzes, :description, :text
  end

  def self.down
    change_column :quizzes, :description, :string
  end
end
