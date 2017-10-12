class DashboardController < ApplicationController
  before_action :verify_code

  def index
    bearer = BearerToken.get_bearer_token(session[:code])
    @api_handler = ApiHandler.new(bearer)
    info = @api_handler.basic_info
    if !(info.is_a?(String))
      user = User.find_or_create_by(name: info[:name])
      session[:user_id] ||= user.id
      user.update(comment_karma: info[:comment_karma], link_karma: info[:link_karma])
    else
      flash[:notice] = info
      redirect_to root_path
    end
  end

end
