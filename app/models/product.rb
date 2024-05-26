class Product < ApplicationRecord
  belongs_to :brand

  validates :name, presence: true, uniqueness: true, on: :create

  validate :status, unless: :brand_is_inactive?

  enum status: { inactive: 0, active: 1 }

  has_many :client_products
  has_many :users, through: :client_products

  private

  def brand_is_inactive?
    if Brand.find(self.brand_id).status == 'inactive' && self.status == 'active'
      errors.add(:status, "can be only inactive because brand is inactive")
    end
  end
end
