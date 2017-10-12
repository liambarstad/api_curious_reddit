class User < ApplicationRecord
  has_many :subscriptions
  has_many :subreddits, through: :subscriptions
end
