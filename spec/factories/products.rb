FactoryBot.define do
  factory :product do
    name { "Test Product" }
    description { "This is a test product" }
    status { "active" }
    price { 55.55 }
    association :brand

    trait :active do
      status { "active" }
    end

    trait :inactive do
      status { "inactive" }
    end
  end
end