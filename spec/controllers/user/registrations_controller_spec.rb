require 'rails_helper'

RSpec.describe User::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'when signup is successful' do
      it 'returns a successful response with the user data' do
        user_attributes = attributes_for(:user)

        post :create, params: {user: user_attributes }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']['code']).to eq(200)
        expect(JSON.parse(response.body)['status']['message']).to eq('Signed up successfully.')
        expect(JSON.parse(response.body)['data']['email']).to eq(user_attributes[:email])
      end
    end

    context 'when signup fails' do
      it 'returns an unprocessable entity response with error message' do
        invalid_attributes = { email: '', password: '' }

        post :create, params: { user: invalid_attributes }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['message']).to match(/User couldn't be created successfully/)
      end
    end
  end
end