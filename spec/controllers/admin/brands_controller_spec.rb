require 'rails_helper'

RSpec.describe Admin::BrandsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:brand) { create(:brand) }

  before do
    sign_in admin_user
  end

  describe 'POST #create' do
    context 'when the brand is successfully created' do
      it 'returns the created brand with status :created' do
        brand_params = attributes_for(:brand)

        post :create, params: { brand: brand_params }, format: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq(brand_params[:name])
      end
    end

    context 'when the brand creation fails' do
      it 'returns errors with status :unprocessable_entity' do
        invalid_params = { name: '', description: '', status: '' }

        post :create, params: { brand: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["status"]).to eql(["can't be blank"])
      end
    end
  end

  describe 'PUT #update' do
    context 'when the brand is successfully updated' do
      it 'returns the updated brand' do
        put :update, params: { id: brand.id, brand: { status: 'inactive' } }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('inactive')
      end

      it 'updates the status of associated products to inactive' do
        put :update, params: { id: brand.id, brand: { status: 'inactive' } }, format: :json

        expect(response).to have_http_status(:ok)
        expect(brand.products.pluck(:status)).to all(eq('inactive'))
      end
    end

    context 'when the brand update fails' do
      it 'returns errors with status :unprocessable_entity' do
        put :update, params: { id: brand.id, brand: { status: '' } }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["status"]).to eql(["can't be blank"])
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the brand' do
      delete :destroy, params: { id: brand.id }, format: :json
      expect(response).to have_http_status(:no_content)
      expect { brand.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
