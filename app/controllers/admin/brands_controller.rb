class Admin::BrandsController < ApplicationController
  before_action :authorize_user!
  before_action :get_brand, only: [:update, :destroy]

  def create
    @brand = Brand.new(create_brand_params)

    if @brand.save
      render json: @brand, status: :created
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  def update
    if @brand.update(update_brand_params)
      if @brand.status == "inactive"
        @brand.products.update_all(status: "inactive")
      end

      render json: @brand
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
  end

  private

  def create_brand_params
    params.require(:brand).permit(:name, :description, :status)
  end

  def update_brand_params
    params.require(:brand).permit(:status)
  end

  def get_brand
    @brand = Brand.find(params[:id])
  end
end