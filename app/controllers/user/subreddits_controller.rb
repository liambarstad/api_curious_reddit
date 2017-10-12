class User::SubredditsController < ApplicationController
  before_action :validate_user, :get_api_handler

  def index
    @api_handler.update_subreddits(current_user)
    @subreddits = current_user.subreddits
    #["data"]["children"].each
    #data => display_name
    #data => title
    #data => header_img
    #data => public_description
    #data => name UNIQUE ID THING
  end

end
