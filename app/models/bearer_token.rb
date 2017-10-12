require 'time'

class BearerToken
  attr_reader :scope
  def initialize(response={})
    @access_token = response["access_token"]
    @expiration_time = DateTime.now + Rational(response["expires_in"].to_i, 86400)
    @scope = response["scope"].to_s.split
    @refresh_token = response["refresh_token"]
  end

  def self.get_bearer_token(code)
    bearer_token = get_bearer_object(code)
    new(bearer_token)
  end

  def self.reinitialize(object)
    bearer = new
    bearer.set_to(object)
  end

  def get_refresh_bearer_object
    if @refresh_token
      conn = format_refresh_token_request
      response = conn.post
      JSON.parse(response.body)
    else; return nil; end
  end

  def authorize_api_call
    if replace_if_expired
      Faraday.new(url: "https://oauth.reddit.com") do |req|
        req.request :multipart
        req.adapter :net_http
        req.headers.store("Authorization", "bearer " + @access_token)
      end
    end
  end

  def set_to(object)
    set(object)
    return self
  end

  private

  attr_accessor :access_token, :expiration_time, :refresh_token
  attr_writer :scope

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

  def replace_if_expired
    if DateTime.now >= @expiration_time
      ref = get_refresh_bearer_object
      if ref["error"].nil?
        initialize(ref)
      else; return nil; end
    else; return true; end
  end

  def set(object)
    @access_token = object["access_token"]
    @expiration_time = object["expiration_time"]
    @scope = object["scope"]
    @refresh_token = object["refresh_token"]
    return self
  end

end
