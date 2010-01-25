# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_notearkiv_session',
  :secret      => '622ee447e12df86b283132f0b03a486dfb493a8f2db09cbe4610f9ea676c439bf5a3a9cedbd901698f8e4e44029ac768b8113377f6c3dbcaa6f08b65aac98737'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
