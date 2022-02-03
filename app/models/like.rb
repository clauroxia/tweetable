class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: true

  validates_uniqueness_of :user_id, scope: [:tweet_id]
end
