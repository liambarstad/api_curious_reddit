require 'time'

class BearerToken
  attr_reader :scope
  def initialize(response)
    @access_token = response["access_token"]
    @expiration_time = DateTime.now + Rational(response["expires_in"], 86400)
    @scope = response["scope"].split
    @refresh_token = response["refresh_token"]
  end

  def self.get_bearer_token(code)
    bearer_token = get_bearer_object(code)
    new(bearer_token)
  end

  def get_refresh_bearer_object(code)
    if !(@refresh_token.nil?)
      conn = format_refresh_token_request
      response = conn.post
      JSON.parse(response.body)
    else
      self.class.get_bearer_object(code)
    end
  end

  def authorize_api_call(code)
    replace_if_expired(code)
    Faraday.new(url: "https://oauth.reddit.com") do |req|
      req.request :multipart
      req.adapter :net_http
      req.headers.store("Authorization", "bearer " + @access_token)
    end
  end

  private

  def self.get_bearer_object(code)
    conn = format_bearer_token_request(code)
    response = conn.post
    JSON.parse(response.body)
  end

  def self.format_bearer_token_request(code)
    Faraday.new(url: "https://www.reddit.com/api/v1/access_token") do |req|
      req.request :multipart
      req.adapter :net_http
      req.basic_auth(ENV["reddit_client_key"], ENV["reddit_secret_key"])
      req.params = bearer_params(code)
    end
  end

  def format_refresh_token_request
    Faraday.new(url: "https://www.reddit.com/api/v1/access_token") do |req|
      req.request :multipart
      req.adapter :net_http
      req.basic_auth(ENV["reddit_client_key"], ENV["reddit_secret_key"])
      req.params = refresh_params
    end
  end

  def self.bearer_params(code)
    { grant_type: "authorization_code", code: code, redirect_uri: "http://localhost:3000/login" }
  end

  def refresh_params
    { grant_type: "refresh_token", refresh_token: @refresh_token }
  end

  def replace_if_expired(code)
    if DateTime.now >= @expiration_time
      initialize(get_refresh_bearer_object(code))
    end
  end

end
