FactoryBot.define do
  factory :client_product do
    association :user
    association :product
  end
end