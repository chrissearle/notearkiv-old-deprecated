class Dropbox::Session
  def self.generate_from_token(consumer_key, consumer_secret, token, token_secret, authorized = true)
    session = self.new(consumer_key, consumer_secret)

    if authorized then
      session.instance_variable_set :@access_token, OAuth::AccessToken.new(session.instance_variable_get(:@consumer), token, token_secret)
    else
      session.instance_variable_set :@request_token, OAuth::RequestToken.new(session.instance_variable_get(:@consumer), token, token_secret)
    end

    return session
  end
end
