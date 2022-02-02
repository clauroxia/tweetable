class Tweet < ApplicationRecord
  # Validations
  validation :body, presence: true, length: { maximum: 140 }

  # Associations
  belongs_to :user

  belongs_to :parent, class_name: "Tweet",
                      optional: true,
                      counter_cache: true
  has_many :replies, class_name: "Tweet",
                     foreign_key: "parent_id",
                     dependent: :destroy,
                     inverse_of: "parent"
end
