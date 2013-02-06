class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string  :title
      t.string  :subject
      t.text    :description
      t.string  :frequency,   :limit => 50
      t.boolean :is_active

      t.timestamps
    end

    add_index :newsletters, :title
  end

  def self.down
    drop_table :newsletters
  end
end
