class User::SubredditsController < ApplicationController
  before_action :validate_user, :get_api_handler

  def index
    status = @api_handler.update_subreddits(current_user)
    if !(status.is_a?(String))
      @subreddits = current_user.subreddits
    else
      flash[:notice] = status
      redirect_to root_path
    end
  end

  def show
    @subreddit = Subreddit.find(params[:id])
    @api_handler.update_posts(@subreddit)
    @posts = @subreddit.posts
  end

end
