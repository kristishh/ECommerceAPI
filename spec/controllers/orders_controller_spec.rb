require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:product) { create(:product) }
  let!(:client_product1) { create(:client_product, product: product, user: user) }
  let!(:client_product2) { create(:client_product, product: product, user: another_user) }
  let(:product_card) { create(:product_card, user: user, product: product, pin_code: '1234') }
  let(:cancelled_product_card) { create(:product_card, user: user, product: product, status: 'cancelled', quantity: 10) }
  let(:order1) { create(:order, product_card: product_card, quantity: 2) }
  let(:order2) { create(:order, product_card: cancelled_product_card, quantity: 1) }

  before do
    sign_in user
  end

  describe "#create" do
    context "with valid parameters" do
      let(:valid_params) { { order: { product_card_id: product_card.id, pin_code: product_card.pin_code, quantity: 1 } } }

      it "creates a new order" do
        product_card.update!(status: "verified")

        expect {
          post :create, params: valid_params
        }.to change(Order, :count).by(1)
      end

      it "returns a created status" do
        product_card.update!(status: "verified")

        post :create, params: valid_params

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid pin code" do
      let(:invalid_pin_code_params) { { order: { product_card_id: product_card.id, pin_code: 'wrong', quantity: 1 } } }

      it "does not create a new order" do
        expect {
          post :create, params: invalid_pin_code_params
        }.not_to change(Order, :count)
      end

      it "returns an unauthorized status" do
        post :create, params: invalid_pin_code_params

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an error message" do
        post :create, params: invalid_pin_code_params

        expect(JSON.parse(response.body)["message"]).to eq("Wrong pin code")
      end
    end

    context "when the product card does not belong to the current user" do
      let(:another_users_card) { create(:product_card, user: another_user, product: product) }
      let(:wrong_user_params) { { order: { product_card_id: another_users_card.id, pin_code: another_users_card.pin_code, quantity: 1 } } }

      it "does not create a new order" do
        expect {
          post :create, params: wrong_user_params
        }.not_to change(Order, :count)
      end

      it "returns a forbidden status" do
        wrong_user_params[:order][:pin_code] = wrong_user_params[:order][:pin_code].to_i + 1

        post :create, params: wrong_user_params

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an error message" do
        post :create, params: wrong_user_params

        expect(JSON.parse(response.body)["message"]).to eq("Card doesn't belong to this user")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { order: { product_card_id: product_card.id, pin_code: product_card.pin_code, quantity: 123 } } }

      it "does not create a new order" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Order, :count)
      end

      it "returns an unprocessable entity status" do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#index' do
    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @all_orders' do
      expect(@controller.instance_variable_get(:@all_orders)).to match_array([order1])
    end

    it 'does not include cancelled product cards' do
      cancelled_product_card.update!(status: "cancelled")
    
      expect(@controller.instance_variable_get(:@all_orders)).not_to include(order2)
    end
  end
end