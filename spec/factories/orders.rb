FactoryBot.define do
  factory :order do
    quantity { rand(1..5) }
    association :product_card
    status { 'completed' }

    before(:create) do |order|
      order.product_card.update(status: 'verified')
    end
  end
end