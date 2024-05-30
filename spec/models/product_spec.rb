require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:brand) { create(:brand) }
  let(:active_product) { create(:product, status: 'active') }
  let(:inactive_product) { create(:product, status: 'inactive') }

  describe "associations" do

    it { should belong_to(:brand) }
    it { should have_many(:product_cards) }
    it { should have_many(:client_products) }
    it { should have_many(:users).through(:client_products) }
  end

  describe "validations" do
    subject { Product.new(name: "new product", price: 50, status: 0, brand: brand) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.on(:create) }

    context "custom validation" do
      let(:brand) { create(:brand, status: 'inactive') }
      let(:product) { build(:product, brand: brand, status: 'active') }

      it "validates that product cannot be active if brand is inactive" do
        expect(product).not_to be_valid
        expect(product.errors[:status]).to include("can be only inactive because brand is inactive")
      end
    end
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(inactive: 0, active: 1) }
  end

  describe "methods" do
    describe "#active?" do
      it "returns true if the product is active" do
        expect(active_product.active?).to be true
      end

      it "returns false if the product is inactive" do
        expect(inactive_product.active?).to be false
      end
    end

    describe "#inactive?" do
      it "returns true if the product is inactive" do
        expect(inactive_product.inactive?).to be true
      end

      it "returns false if the product is active" do
        expect(active_product.inactive?).to be false
      end
    end
  end
end