class User::SubredditsController < ApplicationController
  before_action :validate_user, :get_api_handler

  def index
    binding.pry
  end

end
