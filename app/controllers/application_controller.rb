class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,
                :validate_user

  def current_user
    @current_user ||= User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def validate_user
    unless @current_user
      redirect_to root_path
    end
  end

  protected

  def format_bearer_token_request
    Faraday.new(url: "https://www.reddit.com/api/v1/access_token") do |req|
      req.request :multipart
      req.adapter :net_http
      req.basic_auth(ENV["reddit_client_key"], ENV["reddit_secret_key"])
      req.params = { grant_type: "authorization_code",
                   code: session[:code],
                   redirect_uri: "http://localhost:3000/login" }
    end
  end

end
