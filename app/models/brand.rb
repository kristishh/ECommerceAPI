class Brand < ApplicationRecord
  has_many :products, dependent: :destroy

  enum status: { active: 0, inactive: 1 }

  validates :name, presence: true, uniqueness: true, on: :create
  validates :status, presence: true
end
