class Post < ApplicationRecord
  belongs_to :subreddit

  def self.update_from_response(response, subreddit)
    response["data"]["children"].each do |obj|
      post = subreddit.posts.find_or_create_by(uid: obj["data"]["id"])
      post.update(title: obj["data"]["title"],
                  author: obj["data"]["author"],
                  image: obj["data"]["preview"]["image"][0]["source"]["url"],
                  body: obj["data"]["selftext"],
                  link: obj["data"]["url"])
    end
  end

end
