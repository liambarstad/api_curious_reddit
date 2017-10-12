class DashboardController < ApplicationController

  def index
    bearer = BearerToken.get_bearer_token(session[:code])
    @api_handler = ApiHandler.new(bearer, session[:code])
    @api_handler.basic_info
  end

end
