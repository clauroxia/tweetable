class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :name, presence: true
  validates :email, :username, uniqueness: true, presence: true
  validates :password, length: { minimum: 6 }

  validates :email,
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/,
                      message: "must have an email format" }
  # \A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z
  # Enum
  enum role: { member: 0, admin: 1 }

  # Associations
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar
end
