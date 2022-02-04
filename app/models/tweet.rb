class Tweet < ApplicationRecord
  # Validations
  validates :body, presence: true, length: { maximum: 140 }

  # Associations
  belongs_to :user

  belongs_to :parent, class_name: "Tweet",
                      optional: true,
                      counter_cache: :replies_count
  has_many :replies, class_name: "Tweet",
                     foreign_key: "parent_id",
                     dependent: :destroy,
                     inverse_of: "parent"
  has_many :likes, dependent: :destroy

  # Methods
  def liked?(user)
    !!self.likes.find { |like| like.user_id == user.id }
  end
end
