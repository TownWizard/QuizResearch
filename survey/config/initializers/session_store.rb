# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gsession',
  :secret      => 'bcf26e36204357e0fc570598fb7ae300faa305d106f545182c453778afe07655ad63c60b89f14b40a7eee868b5dd26c680e511c959ca9519dbdd57db199e3de4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
