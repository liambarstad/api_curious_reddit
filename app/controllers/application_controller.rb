class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def format_bearer_token_request
    Faraday.new(url: "https://www.reddit.com/api/v1/access_token") do |req|
      req.basic_auth(ENV["reddit_client_key"], ENV["reddit_secret_key"])
      req.body.merge!({ grant_type: "authorization_code",
                        code: session[:code],
                        redirect_uri: "http://localhost:3000/login" })
    end
  end

end
