class DashboardController < ApplicationController
  # before_action :validate_user

  def index
    conn = format_bearer_token_request
    response = conn.post
    bearer_token = JSON.parse(response.body)
    @bearer = BearerToken.create(bearer_token)
  end

end
