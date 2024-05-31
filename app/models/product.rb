class Product < ApplicationRecord
  has_paper_trail

  belongs_to :brand

  validates :name, presence: true, uniqueness: { case_sensitive: false }, on: :create
  validate :status, unless: :brand_is_inactive?


  enum status: { inactive: 0, active: 1 }

  has_many :product_cards
  has_many :client_products
  has_many :users, through: :client_products

  after_commit :cancel_product_cards_if_needed

  def active?
    self.status == "active"
  end

  def inactive?
    self.status == "inactive"
  end

  private

  def cancel_product_cards_if_needed
    if self.status == "inactive"
      self.product_cards.update_all(status: "cancelled")
    end
  end

  def brand_is_inactive?
    return unless self.brand_id.present?

    if Brand.find(self.brand_id).status == 'inactive' && self.status == 'active'
      errors.add(:status, "can be only inactive because brand is inactive")
    end
  end
end
