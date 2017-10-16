class Subreddit < ApplicationRecord
  has_many :subscriptions
  has_many :posts
  has_many :users, through: :subscriptions

  before_save :set_default_image

  def self.update_from_response(response, user)
    response["data"]["children"].each do |js_object|
      rb_object = find_or_create_by(uid: js_object["data"]["name"])
      rb_object.update(title: js_object["data"]["display_name"],
                       subtitle: js_object["data"]["title"],
                       description: js_object["data"]["public_description"],
                       image_path: js_object["data"]["icon_img"])
      Subscription.find_or_create_by(user: user, subreddit: rb_object)
    end
  end

  private

  def set_default_image
    if image_path.nil? || image_path.empty?
      self.update(image_path: "https://cdn.worldvectorlogo.com/logos/reddit.svg")
    end
  end

end
