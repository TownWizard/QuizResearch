class CreateActiveNewsletters < ActiveRecord::Migration
  def self.up
    create_table :active_newsletters do |t|
      t.integer :newsletter_id
      t.string  :overriding_subject
      t.text    :overriding_description
      t.string  :file_name
      t.date    :start_date

      t.timestamps
    end

    add_index :active_newsletters, :newsletter_id
  end

  def self.down
    drop_table :active_newsletters
  end
end
