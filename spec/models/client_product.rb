require 'rails_helper'

RSpec.describe ClientProduct, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe "validations" do
    context "custom validation" do
      let(:user) { create(:user) }
      let(:product) { create(:product) }

      it "is valid if the product is not already added to the user" do
        client_product = build(:client_product, user: user, product: product)
        expect(client_product).to be_valid
      end

      it "is not valid if the product is already added to the user" do
        create(:client_product, user: user, product: product)
        duplicate_client_product = build(:client_product, user: user, product: product)
        
        expect(duplicate_client_product).not_to be_valid
        expect(duplicate_client_product.errors[:product_id]).to include("already added for this client")
      end
    end
  end
end