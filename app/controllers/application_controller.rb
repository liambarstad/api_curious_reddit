class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,
                :validate_user,
                :verify_code

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

end
