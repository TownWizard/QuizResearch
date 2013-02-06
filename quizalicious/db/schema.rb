# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111201105448) do

  create_table "addresses", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zipcode"
    t.integer  "country_id"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_name"
  end

  add_index "addresses", ["country_id"], :name => "fk_addresses_country_id"
  add_index "addresses", ["state_id"], :name => "fk_addresses_state_id"

  create_table "answer_display_types", :force => true do |t|
    t.string "display_type", :limit => 50
  end

  create_table "answer_response_types", :force => true do |t|
    t.string "response_type", :limit => 50
  end

  create_table "assets", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.integer  "attachment_size"
    t.integer  "position"
    t.string   "type"
    t.datetime "attachment_updated_at"
  end

  create_table "configurations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "configurations", ["name", "type"], :name => "index_configurations_on_name_and_type"

  create_table "countries", :force => true do |t|
    t.string  "iso_name"
    t.string  "iso"
    t.string  "name"
    t.string  "iso3"
    t.integer "numcode"
  end

  create_table "creditcard_txns", :force => true do |t|
    t.integer  "creditcard_payment_id"
    t.decimal  "amount",                :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "txn_type"
    t.string   "response_code"
    t.text     "avs_response"
    t.text     "cvv_response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "creditcard_txns", ["creditcard_payment_id"], :name => "fk_creditcard_txns_creditcard_payment_id"

  create_table "creditcards", :force => true do |t|
    t.integer  "order_id"
    t.text     "number"
    t.string   "month"
    t.string   "year"
    t.text     "verification_value"
    t.string   "cc_type"
    t.string   "display_number"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
  end

  add_index "creditcards", ["order_id"], :name => "index_creditcards_on_order_id"

  create_table "facebook_instances", :force => true do |t|
    t.integer  "facebook_quiz_id"
    t.integer  "quiz_instance_id"
    t.integer  "quiz_instance_uuid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gateway_configurations", :force => true do |t|
    t.integer  "gateway_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gateway_option_values", :force => true do |t|
    t.integer  "gateway_configuration_id"
    t.integer  "gateway_option_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gateway_options", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "gateway_id"
    t.boolean  "textarea",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gateways", :force => true do |t|
    t.string   "clazz"
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventory_units", :force => true do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.string   "state"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "variant_id"
    t.integer  "quantity",                                 :null => false
    t.decimal  "price",      :precision => 8, :scale => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["variant_id"], :name => "index_line_items_on_variant_id"

  create_table "option_types", :force => true do |t|
    t.string   "name",         :limit => 100
    t.string   "presentation", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_types_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "option_values", :force => true do |t|
    t.integer  "option_type_id"
    t.string   "name"
    t.integer  "position"
    t.string   "presentation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_values_variants", :id => false, :force => true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "option_values_variants", ["variant_id"], :name => "index_option_values_variants_on_variant_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "number",               :limit => 15
    t.decimal  "ship_amount",                        :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "tax_amount",                         :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "item_total",                         :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "total",                              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "ip_address"
    t.text     "special_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.boolean  "checkout_complete"
    t.string   "token"
    t.string   "email"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
  end

  add_index "orders", ["bill_address_id"], :name => "fk_orders_bill_address_id"
  add_index "orders", ["checkout_complete"], :name => "index_orders_on_checkout_complete"
  add_index "orders", ["number"], :name => "index_orders_on_number"
  add_index "orders", ["ship_address_id"], :name => "fk_orders_ship_address_id"
  add_index "orders", ["user_id"], :name => "fk_orders_user_id"

  create_table "partner_site_categories", :force => true do |t|
    t.string   "name"
    t.integer  "partner_site_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partner_site_categories", ["partner_site_id"], :name => "fk_partner_site_categories_partner_site_id"

  create_table "partner_site_categories_quiz_categories", :force => true do |t|
    t.integer  "quiz_category_id"
    t.integer  "partner_site_category_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partner_site_categories_quiz_categories", ["partner_site_category_id"], :name => "fk_partner_cat_quiz_cat"
  add_index "partner_site_categories_quiz_categories", ["quiz_category_id"], :name => "fk_partner_site_categories_quiz_categories_quiz_category_id"

  create_table "partner_sites", :force => true do |t|
    t.string   "key",          :limit => 50
    t.string   "host",         :limit => 50, :default => "www", :null => false
    t.string   "domain",                     :default => "",    :null => false
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "display_name",                                  :null => false
  end

  add_index "partner_sites", ["key"], :name => "index_cobrands_on_key", :unique => true
  add_index "partner_sites", ["partner_id"], :name => "fk_partner_sites_partner_id"

  create_table "partners", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "partners", ["name"], :name => "index_cobrand_groups_on_name", :unique => true

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",        :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "creditcard_id"
    t.string   "type"
  end

  add_index "payments", ["creditcard_id"], :name => "fk_payments_creditcard_id"
  add_index "payments", ["order_id"], :name => "fk_payments_order_id"

  create_table "preferences", :force => true do |t|
    t.string   "attribute",  :null => false
    t.integer  "owner_id",   :null => false
    t.string   "owner_type", :null => false
    t.integer  "group_id"
    t.string   "group_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "attribute", "group_id", "group_type"], :name => "index_preferences_on_owner_and_attribute_and_preference", :unique => true

  create_table "product_option_types", :force => true do |t|
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_properties", :force => true do |t|
    t.integer  "product_id"
    t.integer  "property_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                                               :default => "", :null => false
    t.text     "description"
    t.decimal  "master_price",         :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.datetime "available_on"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "deleted_at"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "brand"
    t.text     "notes"
    t.integer  "wholesale_price"
    t.integer  "vendor_id"
  end

  add_index "products", ["available_on"], :name => "index_products_on_available_on"
  add_index "products", ["deleted_at"], :name => "index_products_on_deleted_at"
  add_index "products", ["name"], :name => "index_products_on_name"
  add_index "products", ["permalink"], :name => "index_products_on_permalink"

  create_table "products_taxons", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
  end

  add_index "products_taxons", ["product_id"], :name => "index_products_taxons_on_product_id"
  add_index "products_taxons", ["taxon_id"], :name => "index_products_taxons_on_taxon_id"

  create_table "properties", :force => true do |t|
    t.string   "name"
    t.string   "presentation", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "prototypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provider_recipients", :force => true do |t|
    t.integer  "partner_id"
    t.integer  "recipient_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_recipients", ["partner_id"], :name => "fk_provider_recipients_partner_id"
  add_index "provider_recipients", ["recipient_id"], :name => "fk_provider_recipients_recipient_id"

  create_table "quiz_answers", :force => true do |t|
    t.integer  "quiz_question_id"
    t.string   "answer"
    t.integer  "value"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                  :default => true,  :null => false
    t.text     "boost_keywords"
    t.integer  "answer_response_type_id", :default => 1,     :null => false
    t.integer  "size"
    t.integer  "maxlength"
    t.integer  "rows"
    t.integer  "cols"
    t.boolean  "multiple",                :default => false, :null => false
    t.integer  "next_quiz_phase_id"
    t.string   "answer_image_url"
    t.string   "answer_video_url"
  end

  add_index "quiz_answers", ["quiz_question_id"], :name => "fk_quiz_answers_quiz_question_id"

  create_table "quiz_categories", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "boost_keywords"
  end

  create_table "quiz_instances", :force => true do |t|
    t.string   "quiz_instance_uuid"
    t.integer  "quiz_id"
    t.integer  "user_id"
    t.boolean  "completed",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lead_answer_id"
    t.string   "partner_user_id"
    t.integer  "partner_site_id"
  end

  add_index "quiz_instances", ["partner_site_id"], :name => "fk_quiz_instances_partner_site_id"
  add_index "quiz_instances", ["quiz_id"], :name => "fk_quiz_instances_quiz_id"
  add_index "quiz_instances", ["quiz_instance_uuid"], :name => "qi_quiz_instance_quiz_instance"
  add_index "quiz_instances", ["user_id"], :name => "fk_quiz_instances_user_id"

  create_table "quiz_learning_blurbs", :force => true do |t|
    t.integer  "quiz_answer_id"
    t.string   "name"
    t.text     "blurb"
    t.boolean  "active",         :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "boost_keywords"
  end

  add_index "quiz_learning_blurbs", ["quiz_answer_id"], :name => "fk_quiz_learning_blurbs_quiz_answer_id"

  create_table "quiz_phases", :force => true do |t|
    t.integer  "quiz_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             :default => true, :null => false
    t.text     "boost_keywords"
    t.string   "description"
    t.integer  "branch_question_id"
  end

  add_index "quiz_phases", ["quiz_id"], :name => "fk_quiz_phases_quiz_id"

  create_table "quiz_questions", :force => true do |t|
    t.string   "question"
    t.boolean  "active",                 :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quiz_phase_id"
    t.integer  "position"
    t.text     "boost_keywords"
    t.integer  "answer_display_type_id", :default => 1,     :null => false
    t.boolean  "skip_allowed",           :default => false, :null => false
  end

  add_index "quiz_questions", ["quiz_phase_id"], :name => "fk_quiz_questions_quiz_phase_id"

  create_table "quiz_recommendations", :force => true do |t|
    t.integer  "quiz_id"
    t.string   "name"
    t.text     "recommendation"
    t.float    "value_floor"
    t.float    "value_ceiling"
    t.boolean  "active",         :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "boost_keywords"
  end

  add_index "quiz_recommendations", ["quiz_id"], :name => "fk_quiz_recommendations_quiz_id"

  create_table "quizzes", :force => true do |t|
    t.integer  "quiz_category_id"
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "boost_keywords"
    t.string   "quiz_photo_path"
    t.string   "description"
    t.integer  "partner_id"
  end

  add_index "quizzes", ["partner_id"], :name => "fk_quizzes_partner_id"
  add_index "quizzes", ["quiz_category_id"], :name => "fk_quizzes_quiz_category_id"

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.integer "partner_site_id"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "fk_roles_users_user_id"

  create_table "shared_quizzes", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "partner_site_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  add_index "shared_quizzes", ["partner_site_id"], :name => "fk_shared_quizzes_partner_site_id"
  add_index "shared_quizzes", ["quiz_id"], :name => "fk_shared_quizzes_quiz_id"

  create_table "shipments", :force => true do |t|
    t.integer  "order_id"
    t.integer  "shipping_method_id"
    t.string   "tracking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
    t.decimal  "cost",               :precision => 8, :scale => 2
    t.datetime "shipped_at"
    t.integer  "address_id"
  end

  add_index "shipments", ["address_id"], :name => "fk_shipments_address_id"
  add_index "shipments", ["order_id"], :name => "fk_shipments_order_id"
  add_index "shipments", ["shipping_method_id"], :name => "fk_shipments_shipping_method_id"

  create_table "shipping_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipping_methods", :force => true do |t|
    t.integer  "zone_id"
    t.string   "shipping_calculator"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipping_methods", ["zone_id"], :name => "fk_shipping_methods_zone_id"

  create_table "site_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_sessions", ["session_id"], :name => "index_site_sessions_on_session_id"
  add_index "site_sessions", ["updated_at"], :name => "index_site_sessions_on_updated_at"

  create_table "state_events", :force => true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "previous_state"
  end

  create_table "states", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.integer "country_id"
  end

  create_table "suggestions", :force => true do |t|
    t.string   "suggest_email"
    t.string   "suggest_type"
    t.integer  "suggest_id"
    t.boolean  "emailed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_instances", :force => true do |t|
    t.string   "customer_email"
    t.integer  "store_code"
    t.integer  "survey_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quiz_instance_id"
    t.string   "quiz_instance_uuid"
    t.string   "name_first"
    t.string   "name_last"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zipcode"
    t.string   "phone"
    t.date     "dob"
    t.integer  "year_of_birth",      :limit => 2
    t.string   "register_number",    :limit => 25
    t.string   "cashier_number",     :limit => 25
  end

  add_index "survey_instances", ["quiz_instance_id"], :name => "fk_survey_instances_quiz_instance_id"

  create_table "survey_templates", :force => true do |t|
    t.text     "template_code", :null => false
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", :force => true do |t|
    t.integer  "survey_template_id"
    t.text     "survey_display_instance"
    t.integer  "quiz_id"
    t.integer  "partner_site_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reward_interstitial",                     :null => false
    t.string   "reward_url",              :default => "", :null => false
  end

  add_index "surveys", ["partner_site_id"], :name => "fk_surveys_partner_site_id"
  add_index "surveys", ["quiz_id"], :name => "fk_surveys_quiz_id"
  add_index "surveys", ["survey_template_id"], :name => "fk_surveys_survey_template_id"

  create_table "tax_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tax_rates", :force => true do |t|
    t.integer  "zone_id"
    t.decimal  "amount",          :precision => 8, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tax_type"
    t.integer  "tax_category_id"
  end

  create_table "taxonomies", :force => true do |t|
    t.string   "name",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display_enabled"
    t.integer  "partner_site_id"
    t.boolean  "primary_taxonomy_root"
  end

  add_index "taxonomies", ["partner_site_id"], :name => "fk_taxonomies_partner_site_id"

  create_table "taxons", :force => true do |t|
    t.integer  "taxonomy_id",                :null => false
    t.integer  "parent_id"
    t.integer  "position",    :default => 0
    t.string   "name",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  create_table "user_quiz_answers", :force => true do |t|
    t.integer  "quiz_answer_id"
    t.integer  "user_id"
    t.integer  "quiz_instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_answer_text_response"
  end

  add_index "user_quiz_answers", ["quiz_answer_id"], :name => "fk_user_quiz_answers_quiz_answer_id"
  add_index "user_quiz_answers", ["quiz_instance_id"], :name => "fk_user_quiz_answers_quiz_instance_id"
  add_index "user_quiz_answers", ["user_id"], :name => "fk_user_quiz_answers_user_id"

  create_table "user_types", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name_first",                :limit => 25,  :default => ""
    t.string   "name_last",                 :limit => 25,  :default => ""
    t.string   "email",                     :limit => 100
    t.integer  "user_type_id"
    t.string   "crypted_password",          :limit => 128, :default => "", :null => false
    t.string   "salt",                      :limit => 128, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "dob_confirmed"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.integer  "partner_site_id"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count",                              :default => 0
    t.integer  "failed_login_count",                       :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "partner_id"
    t.string   "facebook_id"
    t.string   "gender"
    t.string   "profile_link"
    t.date     "birthday"
    t.string   "access_token"
    t.datetime "access_token_expires"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["partner_id"], :name => "fk_users_partner_id"
  add_index "users", ["partner_site_id"], :name => "fk_users_partner_site_id"

  create_table "variants", :force => true do |t|
    t.integer  "product_id"
    t.string   "sku",                                      :default => "", :null => false
    t.decimal  "price",      :precision => 8, :scale => 2,                 :null => false
    t.decimal  "weight",     :precision => 8, :scale => 2
    t.decimal  "height",     :precision => 8, :scale => 2
    t.decimal  "width",      :precision => 8, :scale => 2
    t.decimal  "depth",      :precision => 8, :scale => 2
    t.datetime "deleted_at"
  end

  add_index "variants", ["product_id"], :name => "index_variants_on_product_id"

  create_table "zone_members", :force => true do |t|
    t.integer  "zone_id"
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zone_members", ["zone_id"], :name => "fk_zone_members_zone_id"

  create_table "zones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
