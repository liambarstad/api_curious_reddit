class ApiHandler
  def initialize(token, code)
    @bearer = token
    @code = code
  end

  def basic_info
    build = @bearer.authorize_api_call(@code)
    obj = build.get("/api/v1/me")
  end

  def karma

  end

  def subscriptions

  end

  def create_subreddit

  end


end
