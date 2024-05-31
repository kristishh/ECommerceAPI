require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:product_card) { create(:product_card, user: user, product: product, quantity: 5) }
  let(:invalid_product_card) { create(:product_card, user: user, product: product, quantity: 5) }

  describe 'associations' do
    it { should belong_to(:product_card) }
  end

  describe 'validations' do
    it { should validate_presence_of(:product_card) }

    it { should validate_inclusion_of(:status).in_array(%w(completed cancelled)) }

    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }

    context 'when product card is not verified' do
      it 'is not valid' do
        order = Order.new(product_card: invalid_product_card, quantity: 1)

        expect(order).not_to be_valid
        expect(order.errors[:product_card]).to include("is not verified")
      end
    end

    context 'when product card is verified' do
      it 'is valid' do
        product_card.update!(status: "verified")

        order = Order.new(product_card: product_card, quantity: 1)
        expect(order).to be_valid
      end
    end
  end

  describe 'callbacks' do
    context 'before validation' do

      it 'sets status to completed if quantity is available' do
        order = Order.new(product_card: product_card, quantity: 3)
        order.valid?

        expect(order.status).to eq('completed')
        expect(order.product_card.quantity).to eq(2)
      end

      it 'sets status to cancelled if quantity is not available' do
        order = Order.new(product_card: product_card, quantity: 6)
        order.valid?

        expect(order.status).to eq('cancelled')
        expect(order.product_card.quantity).to eq(-1) # quantity is still deducted
      end

      it 'archives product card if its quantity becomes zero' do
        order = Order.create(product_card: product_card, quantity: 5)

        expect(order.status).to eq('completed')
        expect(order.product_card.status).to eq('archived')
        expect(order.product_card.quantity).to eq(0)
      end
    end
  end
end
