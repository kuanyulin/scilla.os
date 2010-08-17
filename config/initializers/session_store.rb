# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_atoffice_session',
  :secret      => '02e242d6d33d37b558df366b61bb68bd6b194f773093305f6ced4b0c1e54a53f55c4e5f69491075f58f96e466ca583cec1835fea3b99c680e76a170831ea8a5d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
