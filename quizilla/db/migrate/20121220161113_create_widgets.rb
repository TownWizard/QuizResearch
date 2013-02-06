class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.string      :title
      t.references  :partner
      t.references  :quiz
      t.string      :domain_name
      t.string      :top_logo_url
      t.integer     :logo_width
      t.integer     :logo_height
      t.integer     :width
      t.integer     :height
      t.string      :bg_color,    :default => "#FFFFFF"
      t.string      :font_color,  :default => "#0B0202"
      t.string      :font_size
      t.string      :font_family
      t.string      :location, :default => "top: 350px; right: 15px;"
      t.text        :pre_footer_text
      t.string      :contact_us_link
      
      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
  end
end
