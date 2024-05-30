# spec/models/product_card_spec.rb

require 'rails_helper'

RSpec.describe ProductCard, type: :model do
  let(:user) { create(:user) }
  let(:brand) { create(:brand) }
  let(:product) { create(:product, brand: brand) }


  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe "validations" do
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }

    context "custom validations" do
      let(:user) { create(:user) }
      let(:user2) {create(:user, email: "example@gmail.com")}
      let(:product) { create(:product) }
      let!(:product_card) { create(:product_card, user: user, product: product) }

      it "does not allow the same user and product combination more than once" do
        create(:product_card, user: user2, product: product)
        duplicate_product_card = build(:product_card, user: user2, product: product)
        
        expect(duplicate_product_card).not_to be_valid
        expect(duplicate_product_card.errors[:user_id]).to include("already has a card for this product")
      end

      it "does not allow status to be changed for cancelled or already verified cards" do
        product_card.update(status: 'cancelled')
        product_card.update(status: 'verify')

        expect(product_card.errors[:status]).to include("can no longer can be changed")
      end
    end
  end

  describe "callbacks" do
    it "generates a pin code before validation on create" do
      product_card = build(:product_card)
      expect(product_card).to receive(:generate_pin_code)
      product_card.valid?
    end

    it "generates an activation code before validation on create" do
      product_card = build(:product_card)
      expect(product_card).to receive(:generate_activation_code)
      product_card.valid?
    end

    it "sets the default status to unverified before validation on create" do
      product_card = build(:product_card)
      product_card.valid?
      expect(product_card.status).to eq('unverified')
    end
  end

  describe "#verified?" do
    let(:product_card) { create(:product_card) }

    context "in production environment" do
      before do
        stub_const('ENV', {'RAILS_ENV' => 'development'})
      end

      it "returns true if the activation code and pin code are valid" do
        allow(BCrypt::Password).to receive(:new).and_return(double("BCrypt::Password", is_password?: true))
        expect(product_card.verified?(product_card.activation_code, product_card.pin_code)).to be true
      end

      it "returns false if the activation code or pin code are invalid" do
        allow(BCrypt::Password).to receive(:new).and_return(double("BCrypt::Password", is_password?: false))
        expect(product_card.verified?(SecureRandom.hex(8), product_card.pin_code)).to be false
      end
    end

    context "in non-production environment" do
      before do
        stub_const('ENV', {'RAILS_ENV' => 'development'})
      end

      it "returns true if the activation code matches" do
        expect(product_card.verified?(product_card.activation_code)).to be true
      end

      it "returns false if the activation code does not match" do
        expect(product_card.verified?("wrong_code")).to be false
      end
    end
  end

  describe "#authenticated?" do
    let(:product_card) { create(:product_card) }

    context "in production environment" do
      before do
        stub_const('ENV', {'RAILS_ENV' => 'development'})
      end

      it "returns true if the pin code is valid" do
        allow(BCrypt::Password).to receive(:new).and_return(double("BCrypt::Password", is_password?: true))
        expect(product_card.authenticated?(product_card.pin_code)).to be true
      end

      it "returns false if the pin code is invalid" do
        allow(BCrypt::Password).to receive(:new).and_return(double("BCrypt::Password", is_password?: false))
        expect(product_card.authenticated?("wrong_pin")).to be false
      end
    end

    context "in non-production environment" do
      before do
        stub_const('ENV', {'RAILS_ENV' => 'development'})
      end

      it "returns true if the pin code matches" do
        expect(product_card.authenticated?(product_card.pin_code)).to be true
      end

      it "returns false if the pin code does not match" do
        expect(product_card.authenticated?("wrong_pin")).to be false
      end
    end
  end
end
