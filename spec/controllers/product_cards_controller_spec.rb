require 'rails_helper'

RSpec.describe ProductCardsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:product_card_service) { ProductCardService.new(user) }

  before do
    sign_in user
    allow(controller).to receive(:product_card_service).and_return(product_card_service)
  end

  describe '#generate_new' do
    it 'generates a new product card' do
      post :generate_new, params: { card: { product_id: product.id, quantity: 1 } }, format: :json

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key("activation_code")
      expect(json_response["quantity"]).to eq(1)
    end
  end

  describe '#verify' do
    let!(:product_card) { create(:product_card, user: user, product: product) }

    context 'when card exists' do
      it 'verifies the product card' do
        post :verify, params: { card: { product_id: product.id, pin_code: product_card.pin_code, activation_code: product_card.activation_code } }, format: :json

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response["status"]).to eq("verified")
      end
    end

    context 'when card does not exist' do
      it 'returns an error message' do
        post :verify, params: { card: { product_id: product.id + 1, pin_code: "wrong", activation_code: "wrong" } }, format: :json
        
        json_response = JSON.parse(response.body)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["message"]).to eq("Such card doesn't exist")
      end
    end
  end

  describe '#cancel' do
    let!(:product_card) { create(:product_card, user: user, product: product) }

    context 'belongs to the user' do
      it 'cancels the product card' do
        put :cancel, params: { id: product_card.id }, format: :json

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response["status"]).to eq("cancelled")
      end
    end

    context 'when product card does not belong to the user' do
      let(:other_user) { create(:user) }
      let!(:other_product_card) { create(:product_card, user: other_user, product: product) }

      it 'returns an error message' do
        put :cancel, params: { id: other_product_card.id }, format: :json

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:forbidden)
        expect(json_response["message"]).to eq("Product card doesn't belong to this user")
      end
    end
  end
end