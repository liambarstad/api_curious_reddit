class DashboardController < ApplicationController
  before_action :verify_code

  def index
    bearer = BearerToken.get_bearer_token(session[:code])
    @api_handler = ApiHandler.new(bearer, session[:code])
    info = @api_handler.basic_info
    if !(info.nil?)
      @user = User.find_or_create_by(name: info[:name])
      session[:user_id] ||= @user.id
      @user.comment_karma = info[:comment_karma]
      @user.link_karma = info[:link_karma]
    else
      flash[:notice] = "Something went wrong with user validation. Is your account suspended?"
      redirect_to root_path
    end
  end

end
