require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:brand) { create(:brand) }
  let(:product) { create(:product, brand: brand) }

  before do
    sign_in admin_user
  end

  describe '#create' do
    context 'when the product is successfully created' do
      it 'returns the created product with status :created' do
        product_params = attributes_for(:product).merge(brand_id: brand.id)

        post :create, params: { product: product_params }, format: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq(product_params[:name])
      end
    end

    context 'when the product creation fails' do
      it 'returns errors with status :unprocessable_entity' do
        invalid_params = { name: '', description: '', price: nil, status: '', brand_id: brand.id }

        post :create, params: { product: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["name"]).to eql(["can't be blank"])
      end
    end
  end

  describe '#show' do
    it 'returns the product' do
      get :show, params: { id: product.id }, format: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq(product.name)
    end
  end

  describe '#update' do
    context 'when the product is successfully updated' do
      it 'returns the updated product' do
        put :update, params: { id: product.id, product: { status: 'inactive' } }, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('inactive')
      end
    end

    context 'when the product update fails' do
      let(:brand) { create(:brand, :inactive) }
      let(:product) { create(:product, :inactive, brand: brand) }

      it 'returns errors with status :unprocessable_entity' do
        put :update, params: { id: product.id, product: { status: 'active' } }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["status"]).to eql(["can be only inactive because brand is inactive"])
      end
    end
  end

  describe '#destroy' do
    it 'destroys the product' do
      delete :destroy, params: { id: product.id }, format: :json
      expect(response).to have_http_status(:no_content)
      expect { product.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end