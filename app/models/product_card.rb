class ProductCard < ApplicationRecord
  # activation_code and pin_code attributes will be hashed for production
  # but not for local to make code development easier

  belongs_to :user
  belongs_to :product

  validates :activation_code, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w(unverified verified cancelled) }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  
  before_validation :generate_pin_code, on: :create
  before_validation :generate_activation_code, on: :create
  before_validation :set_status, on: :create
  

  validate :can_have_same_user_and_product_once, on: :create
  validate :card_status, on: :update
  
  def verified?(activation_code, pin_code = nil)
    return false unless authenticated?(pin_code) || !pin_code

    return BCrypt::Password.new(activation_code).is_password?(self.authentication_code) if ENV["RAILS_ENV"] == "production"

    activation_code == self.activation_code
  end

  def authenticated?(pin_code)
    return BCrypt::Password.new(pin_code).is_password?(self.pin_code) if ENV["RAILS_ENV"] == "production"
    return self.pin_code == pin_code.to_s
  end

  private 

  def card_status
    product_card = ProductCard.find_by(user_id: self.user_id, product_id: self.product_id)

    return errors.add(:status, "can no longer can be changed") if product_card.status == "cancelled"

    return errors.add(:status, "is already verified") if product_card.status == "verified" && self.status == "verified"

    if product_card.status == "verified" && self.status == "unverified"
      errors.add(:status, "can't unverify already verified card")
    end
  end

  def can_have_same_user_and_product_once 
    if ProductCard.exists?(user_id: self.user_id, product_id: self.product_id)
      errors.add(:user_id, "already has a card for this product")
    end
  end

  def set_status
    self.status = :unverified
  end

  def generate_activation_code
    activation_code = SecureRandom.hex(8)

    self.activation_code = ENV["RAILS_ENV"] == "production" ? BCrypt::Password.create(activation_code) : activation_code
  end

  def generate_pin_code
    pin_code = SecureRandom.random_number(10**4).to_s.rjust(4, '0')
    self.pin_code = ENV["RAILS_ENV"] == "production" ? BCrypt::Password.create(pin_code) : pin_code
  end
end
