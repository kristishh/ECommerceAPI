require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:client_user) { create(:user, :client) }
  let!(:brand) { create(:brand) }
  let!(:product1) { create(:product, name: "Test Product 1", price: 50, brand: brand) }
  let!(:product2) { create(:product, name: "Another Product", price: 150, brand: brand) }
  let!(:product3) { create(:product, name: "Test Product 3", price: 200, brand: brand) }

  before do
    sign_in client_user
  end

  describe '#search' do
    context 'without any search parameters' do
      it 'returns all products' do
        get :search, params: { search_by: { name: ''} }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['products'].length).to eq(3)
      end
    end

    context 'with name parameter' do
      it 'returns products matching the name' do
        get :search, params: { search_by: { name: 'Test' } }, format: :json

        products = JSON.parse(response.body)['products']

        expect(response).to have_http_status(:ok)
        expect(products.length).to eq(2)
        expect(products.map { |p| p['name'] }).to include(product1.name, product3.name)
      end
    end

    context 'with minimum price parameter' do
      it 'returns products with price greater than min price' do
        get :search, params: { search_by: { price: { min: 100 } } }, format: :json

        products = JSON.parse(response.body)['products']

        expect(response).to have_http_status(:ok)
        expect(products.length).to eq(2)
        expect(products.map { |p| p['price'].to_i }).to all(be > 100)
      end
    end

    context 'with maximum price parameter' do
      it 'returns products with price less than or equal to max price' do
        get :search, params: { search_by: { price: { max: 100 } } }, format: :json

        products = JSON.parse(response.body)['products']
        
        expect(response).to have_http_status(:ok)
        expect(products.length).to eq(1)
        expect(products.first['price'].to_i).to be <= 100
      end
    end

    context 'with both min and max price parameters' do
      it 'returns products within the price range' do
        get :search, params: { search_by: { price: { min: 100, max: 200 } } }, format: :json

        products = JSON.parse(response.body)['products']

        expect(response).to have_http_status(:ok)
        expect(products.length).to eq(2)
        expect(products.map { |p| p['price'].to_i }).to all(be_between(100, 200).inclusive)
      end
    end

    context 'with both name and price parameters' do
      it 'returns products matching the name and within the price range' do
        get :search, params: { search_by: { name: 'Product', price: { min: 100, max: 200 } } }, format: :json
        products = JSON.parse(response.body)['products']

        expect(response).to have_http_status(:ok)
        expect(products.length).to eq(2)
        expect(products.first['name']).to eq('Another Product')
        expect(products.first['price'].to_i).to be_between(100, 200).inclusive
      end
    end
  end
end