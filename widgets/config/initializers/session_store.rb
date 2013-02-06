# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_trunk_session',
  :secret      => '1b79c95cb2bce9bbddd1fd3c45d583393cf3f471f4f2a00ff4c2e1973479ebe5b66f7938f0c5672fdb02281b807cc3f30140080015398c9eb289f07f658bc680'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
