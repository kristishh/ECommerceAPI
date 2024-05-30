require 'rails_helper'

RSpec.describe Admin::ClientProductsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:client_user) { create(:user, :client) }
  let(:product) { create(:product) }
  let!(:client_product) { create(:client_product, user: client_user, product: product) }

  before do
    sign_in admin_user
  end

  describe '#get_report' do
    context 'when both user_id and product_id are provided' do
      it 'returns an error message' do
        get :get_report, params: { get_report_by: { user_id: client_user.id, product_id: product.id } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq("Choose between user_id and product_id")
      end
    end

    context 'when report by user_id is requested' do

      it 'returns the report by user' do
        get :get_report, params: { get_report_by: { user_id: client_user.id } }, format: :json

        expect(response).to have_http_status(:ok)
        expect(@controller.instance_variable_get(:@report_by_user)).to eq([client_product])
      end
    end

    context 'when report by product_id is requested' do
      it 'returns the report by product' do
        get :get_report, params: { get_report_by: { product_id: product.id } }, format: :json

        expect(response).to have_http_status(:ok)
        expect(@controller.instance_variable_get(:@report_by_product)).to eq([client_product])
      end
    end

    context 'when no report is found' do
      it 'returns a message indicating nothing was found' do
        get :get_report, params: { get_report_by: { user_id: 0 } }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Nothing was found")
      end
    end
  end

  describe '#set_availability' do
    before do
      allow(User).to receive(:find).and_return(client_user)
    end

    context 'when product_ids are missing' do
      it 'returns an error message' do
        post :set_availability, params: { product_availability: { user_id: client_user.id, product_ids: [] } }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq("List of products_ids is missing")
      end
    end

    context 'when valid product_ids are provided' do
      it 'sets the product availability and returns a success message' do
        post :set_availability, params: { product_availability: { user_id: client_user.id, product_ids: [product.id] } }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Product availability was successfully set.")
      end
    end
  end
end