class ApiHandler
  def initialize(token, code)
    @bearer = token
    @code = code
  end

  def basic_info
    if check_scope("identity")
      build = @bearer.authorize_api_call(@code)
      response = build.get("/api/v1/me")
      traits = JSON.parse(response.body)
      if traits["is_suspended"] == false
        return {name: traits["name"],
                link_karma: traits["link_karma"],
                comment_karma: traits["comment_karma"]}
      else; return nil; end
    else; return nil; end
  end

  def karma

  end

  def subscriptions

  end

  def create_subreddit

  end

  private

  def check_scope(scope)
    @bearer.scope.include?(scope)
  end

end
