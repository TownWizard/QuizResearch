class RemoveDefunctAffiliateProductInfrastructure < ActiveRecord::Migration
  def self.up
    drop_table :affiliate_products
    drop_table :affiliate_product_quiz_learning_blurb_bindings
    drop_table :affiliate_product_quiz_recommendation_bindings
  end

  def self.down
    create_table "affiliate_products", :force => true do |t|
      t.string   "name"
      t.text     "description"
      t.text     "html"
      t.string   "image"
      t.boolean  "active"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "affiliate_product_quiz_learning_blurb_bindings", :force => true do |t|
      t.integer  "affiliate_product_id"
      t.integer  "quiz_learning_blurb_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "affiliate_product_quiz_recommendation_bindings", :force => true do |t|
      t.integer  "affiliate_product_id"
      t.integer  "quiz_recommendation_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

  end
end
