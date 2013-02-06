class AddNewFeatures < ActiveRecord::Migration
  def self.up
    create_table :answer_display_types do |t|
      t.integer :id
      t.string :display_type,   :limit => 50
    end
    
    execute "INSERT INTO answer_display_types (id, display_type) VALUES (1, 'RADIO')"
    execute "INSERT INTO answer_display_types (id, display_type) VALUES (2, 'CHECKBOX')"
    execute "INSERT INTO answer_display_types (id, display_type) VALUES (3, 'SELECT')"
    execute "INSERT INTO answer_display_types (id, display_type) VALUES (4, 'TEXT')"
    execute "INSERT INTO answer_display_types (id, display_type) VALUES (5, 'TEXTAREA')"


    create_table :answer_response_types do |t|
      t.integer :id
      t.string :response_type,   :limit => 50
    end

    execute "INSERT INTO answer_response_types (id, response_type) VALUES (1, 'FIXED')"
    execute "INSERT INTO answer_response_types (id, response_type) VALUES (2, 'TEXT')"
    execute "INSERT INTO answer_response_types (id, response_type) VALUES (3, 'TEXTAREA')"
    execute "INSERT INTO answer_response_types (id, response_type) VALUES (4, 'FILEUPLOAD')"

    add_column :quiz_questions, :answer_display_type_id, :integer, :default => 1, :null => false
    add_column :quiz_questions, :skip_allowed, :boolean, :default => false, :null => false
    add_column :quiz_answers, :answer_response_type_id, :integer, :default => 1, :null => false
    add_column :quiz_answers, :size, :integer
    add_column :quiz_answers, :maxlength, :integer
    add_column :quiz_answers, :rows, :integer
    add_column :quiz_answers, :cols, :integer
    add_column :quiz_answers, :multiple, :boolean, :default => false, :null => false
    add_column :quiz_answers, :next_quiz_phase_id, :integer
    add_column :quiz_answers, :answer_image_url, :string
    add_column :quiz_answers, :answer_video_url, :string
    add_column :quiz_phases, :branch_question_id, :integer
    add_column :user_quiz_answers, :user_answer_text_response, :string
  end

  def self.down
    remove_column :quiz_questions, :answer_display_type_id
    remove_column :quiz_questions, :skip_allowed
    remove_column :quiz_answers, :answer_response_type_id
    remove_column :quiz_answers, :size
    remove_column :quiz_answers, :maxlength
    remove_column :quiz_answers, :rows
    remove_column :quiz_answers, :cols
    remove_column :quiz_answers, :multiple
    remove_column :quiz_answers, :next_quiz_phase_id
    remove_column :quiz_answers, :answer_image_url
    remove_column :quiz_answers, :answer_video_url
    remove_column :quiz_phases, :branch_question_id
    remove_column :user_quiz_answers, :user_answer_text_response
 
    drop_table :answer_display_types
    drop_table :answer_response_types
  end
end

