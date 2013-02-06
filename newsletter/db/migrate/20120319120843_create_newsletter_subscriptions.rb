class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscriptions do |t|
      t.integer   :subscriber_id
      t.integer   :newsletter_id
      t.boolean   :opt_in
      t.datetime  :last_submitted
      t.boolean   :last_submitted_success
      t.string    :submit_error,          :limit => 5000
      t.integer   :retry_count,           :default => 3

      t.timestamps
    end

    add_index :newsletter_subscriptions, [:subscriber_id, :newsletter_id], :name => "by_newsletter_subscriber"
  end

  def self.down
    drop_table :newsletter_subscriptions
  end
end
