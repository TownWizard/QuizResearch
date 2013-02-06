# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_quimpl_session',
  :secret      => '1b3bb8394d7cf9060e3f79e8f7dc2013ff855ae278b4b3a0d3b852ccee38f6f713c4d9f349ebbabd9eee8fb7ea00f1a81120575cd40a06649566d30ea6558e49'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
