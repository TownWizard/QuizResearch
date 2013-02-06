# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_newsletter_session',
  :secret      => 'b2e77aebeff7e1b3a32ae286b175579feaabc84d0b7c59cf6549c5169cca75e271084afb328ccdad6a74f8495ead3423d688090f3860bb8fc17fd11542000e5d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
