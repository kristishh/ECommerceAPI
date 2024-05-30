FactoryBot.define do
  factory :product_card do
    activation_code { "ae634bf51583e561" }
    pin_code { "7890" }
    status { "active" }
    quantity { 50 }
    association :user
    association :product
  end
end