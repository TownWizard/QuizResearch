class CreateFacebookQuizzes < ActiveRecord::Migration
  def self.up
    create_table :facebook_quizzes do |t|
      t.integer :quiz_id
      t.integer :partner_site_id
      t.string  :title
      t.string  :offer_url
      t.boolean :is_active

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_quizzes
  end
end
