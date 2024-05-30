require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  
  before do
    sign_in admin_user
  end

  describe '#create_client' do
    context 'with valid attributes' do
      it 'creates a new client' do
        client_attributes = attributes_for(:user, :client)
        post :create_client, params: { user: client_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['email']).to eq(client_attributes[:email])
      end
    end

    context 'with invalid attributes' do
      it 'returns an error message' do
        post :create_client, params: { user: { email: '', password: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["email"]).to eq(["can't be blank", "is invalid"])
      end
    end
  end
end