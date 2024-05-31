class Order < ApplicationRecord
  belongs_to :product_card

  validates_presence_of :product_card

  validates :status, inclusion: { in: %w(completed cancelled) }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  validate :product_card_is_verified?

  before_validation :set_status, on: :create

  def product_card_is_verified?
    return unless self.product_card.present?

    return errors.add(:product_card, "is not verified") unless self.product_card.status == "verified"
  end

  private

  def set_status
    return unless self.product_card.present?

    new_quantity = self.product_card.quantity - self.quantity

    self.status = new_quantity >= 0 ? "completed" : "cancelled"

    self.product_card.update(quantity: new_quantity)

    self.product_card.quantity == 0 && self.product_card.update!(status: "archived")
  end
end
