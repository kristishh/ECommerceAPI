class Admin::ProductsController < ApplicationController
  before_action :authorize_user!
  before_action :set_product, only: [:show, :update, :destroy]

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @product
  end

  def update
    if @product.update(update_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :status, :brand_id)
  end

  def update_params
    params.require(:product).permit(:status)
  end
end