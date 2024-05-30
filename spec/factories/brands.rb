FactoryBot.define do
  factory :brand do
    name { "Test Brand" }
    description { "This is a test brand" }
    status { "active" }

    trait :active do
      status { "active" }
    end

    trait :inactive do
      status { "inactive" }
    end
  end
end