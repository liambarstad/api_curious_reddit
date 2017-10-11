class DashboardController < ApplicationController
  # before_action :validate_user

  def index
    conn = format_bearer_token_request
    user_info = conn.post("/me").body
    binding.pry
  end

end
