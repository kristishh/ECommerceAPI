FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    payout_rate { 20 }

    trait :client do
      role { 'client' }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end