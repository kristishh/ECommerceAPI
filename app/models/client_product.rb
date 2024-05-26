class ClientProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validate :product_already_added_to_user

  private

  def product_already_added_to_user
    if User.find(self.user_id).client_products.find_by(product_id: self.product_id).present?
      errors.add(:product_id, "already added for this client")
    end
  end
end
