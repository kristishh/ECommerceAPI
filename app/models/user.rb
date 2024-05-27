class User < ApplicationRecord
  has_paper_trail

  include Devise::JWT::RevocationStrategies::JTIMatcher
  include ActionView::Helpers::NumberHelper

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
  validates :payout_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  enum role: { client: 0, admin: 1 }

  after_initialize :set_default_role

  has_many :client_products
  has_many :products, through: :client_products

  def is_admin?
    self.role == "admin"
  end

  private
  
  def set_default_role
    self.role ||= :client
  end
end
