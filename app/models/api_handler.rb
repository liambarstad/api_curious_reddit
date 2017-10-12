class ApiHandler
  def initialize(token)
    @bearer = token
  end

  def basic_info
    if check_scope("identity")
      response = get_parse("/api/v1/me")
      if response
        if response["is_suspended"] == false
          return {name: response["name"],
                  link_karma: response["link_karma"],
                  comment_karma: response["comment_karma"]}
        else; return "Account has been suspended"; end
      else; return "Session has expired, please log in"; end
    else; return "Scope is not available"; end
  end

  def subscriptions
    if check_scope("mysubreddits")
      response = get_parse("/subreddits/mine/subscriber")

    else; return "Scope is not available"; end
  end

  def create_subreddit

  end

  private

  def check_scope(scope)
    @bearer.scope.include?(scope)
  end

  def get_parse(path)
    build = @bearer.authorize_api_call
    if build
      response = build.get(path)
      return JSON.parse(response.body)
    else; return nil; end
  end

end
