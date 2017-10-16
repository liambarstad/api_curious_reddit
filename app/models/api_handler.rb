class ApiHandler
  def initialize(token)
    @bearer = token
  end

  def basic_info
    catch(1) do
      check_scope("identity")
      response = get_parse("/api/v1/me")
      check_response(response)
      check_if_suspended(response)
      return {name: response["name"], link_karma: response["link_karma"], comment_karma: response["comment_karma"]}
    end
  end

  def update_subreddits(user)
    catch(1) do
      check_scope("mysubreddits")
      response = get_parse("/subreddits/mine/subscriber")
      check_response(response)
      Subreddit.update_from_response(response, user); return true
    end
  end

  def update_posts(subreddit)
    catch(1) do
      check_scope("...")
      response = get_parse("/r/#{subreddit.title}")
      check_response(response)
      Post.update_from_response(response, subreddit); return true
    end
  end

  def create_subreddit

  end

  private

  def check_scope(scope)
    if !(@bearer.scope.include?(scope))
      throw(1, "Scope is not available")
    end
  end

  def check_response(response)
    if response.nil?
      throw(1, "Session has expired, please log in")
    end
  end

  def check_if_suspended(response)
    if response["is_suspended"] == true
      throw(1, "Account has been suspended")
    end
  end

  def get_parse(path)
    catch(2) do
      build = @bearer.authorize_api_call
      check_call(build)
      response = build.get(path)
      return JSON.parse(response.body)
    end
  end

  def check_call(call)
    if call.nil?
      throw(2, nil)
    end
  end

end
