class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,
                :validate_user,
                :verify_code,
                :set_api_handler,
                :get_api_handler

  def current_user
    @current_user ||= User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def validate_user
    unless current_user
      redirect_to root_path
    end
  end

  def verify_code
    unless session[:code]
      redirect_to root_path
    end
  end

  def set_api_handler
    if session[:api_handler].nil?
      bearer = BearerToken.get_bearer_token(session[:code])
      @api_handler = ApiHandler.new(bearer)
      session[:api_handler] = @api_handler
    else; get_api_handler; end
  end

  def get_api_handler
    if session[:api_handler]
      bearer = BearerToken.reinitialize(session[:api_handler]["bearer"])
      @api_handler = ApiHandler.new(bearer)
    else
      flash[:notice] = "Please log in again"
      redirect_to root_path
    end
  end

end
