require 'open-uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

  # Validations
  validates :name, presence: true
  validates :email, :username, uniqueness: true, presence: true
  validates :encrypted_password, length: { minimum: 6 }

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

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
      user.username = auth_hash.info.nickname
      user.email = auth_hash.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth_hash.info.nickname
      user.avatar.attach(io: URI.open(auth_hash.info.image.to_s), filename: "#{auth_hash.info.nickname}-avatar.jpg")
    end
  end
end
