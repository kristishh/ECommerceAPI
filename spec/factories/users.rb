FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    payout_rate { rand(10..50) }

    trait :client do
      role { 'client' }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end