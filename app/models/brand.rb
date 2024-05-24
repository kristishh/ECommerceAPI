class Brand < ApplicationRecord
  has_many :products, dependent: :destroy

  enum status: { inactive: 0, active: 1 }

  validates :name, presence: true, uniqueness: true, on: :create
  validates :status, presence: true
end
