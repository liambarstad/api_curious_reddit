class WelcomeController < ApplicationController
  include KeyHandler

  def index
    state = KeyHandler.random_key
    @url = KeyHandler.oauth_url(state)
  end

end
