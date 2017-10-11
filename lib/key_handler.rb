module KeyHandler

  def self.oauth_url(key)
    "https://www.reddit.com/api/v1/authorize?client_id=#{ENV["reddit_client_key"]}&response_type=code&state=#{key}&redirect_uri=http://localhost:3000/login&duration=permanent&scope=identity,modconfig,mysubreddits,vote,privatemessages,read"
  end

  def self.random_key
    key = ""
    10.times do
      key += rand(97..122).chr
    end
    key
  end

  def self.test_username
    ENV["reddit_username"]
  end

  def self.test_password
    ENV["reddit_password"]
  end

end
