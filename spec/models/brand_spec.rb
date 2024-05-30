require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe "associations" do
    it { should have_many(:products).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.on(:create) }
    it { should validate_presence_of(:status) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(inactive: 0, active: 1) }
  end
end