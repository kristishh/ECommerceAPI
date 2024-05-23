class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_secure_password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
    :trackable,
    :rememberable,
    :validatable,
    :registerable,
    :jwt_authenticatable,
    jwt_revocation_strategy: self  
  
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  enum role: { client: 0, admin: 1 }

  after_initialize :set_default_role

  private
  
  def set_default_role
    self.role ||= :client
  end
end
