class Brand < ApplicationRecord
  has_paper_trail

  has_many :products, dependent: :destroy

  enum status: { inactive: 0, active: 1 }

  validates :name, presence: true, uniqueness: { case_sensitive: false }, on: :create
  validates :status, presence: true

  after_commit :set_product_status

  private

  def set_product_status
    if self.status == "inactive"
      products = self.products.update_all(status: "inactive")
    end
  end
end
