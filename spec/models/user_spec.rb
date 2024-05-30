require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:product_cards) }
    it { should have_many(:client_products) }
    it { should have_many(:products).through(:client_products) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(client: 0, admin: 1) }
  end

  describe "callbacks" do
    it "sets default role to client" do
      user = User.new
      expect(user.role).to eq("client")
    end
  end

  describe "#is_admin?" do
    it "returns true if the user is an admin" do
      admin_user = create(:user, role: :admin)
      expect(admin_user.is_admin?).to eq(true)
    end

    it "returns false if the user is not an admin" do
      client_user = create(:user, role: :client)
      expect(client_user.is_admin?).to eq(false)
    end
  end

  describe "devise modules" do
    it "includes database_authenticatable" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "includes jwt_authenticatable" do
      expect(User.devise_modules).to include(:jwt_authenticatable)
    end

    it "includes rememberable" do
      expect(User.devise_modules).to include(:rememberable)
    end

    it "includes trackable" do
      expect(User.devise_modules).to include(:trackable)
    end

    it "includes validatable" do
      expect(User.devise_modules).to include(:validatable)
    end

    it "includes registerable" do
      expect(User.devise_modules).to include(:registerable)
    end
  end
end