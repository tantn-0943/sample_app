class User < ApplicationRecord
  before_save{email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.length.name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: {maximum: Settings.length.email}, presence: true,
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.length.password}
  def self.digest string
    # cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    #   BCrypt::Engine.cost
    # BCrypt::Password.create(string, cost: cost)
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create(string, cost: BCrypt::Engine::MIN_COST)
    else
      BCrypt::Password.create(string, cost: BCrypt::Engine.cost)
    end
  end
end
