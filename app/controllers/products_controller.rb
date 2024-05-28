class ProductsController < ApplicationController
  def search
    @product_list = Product.all

    if search_params[:name].present?
      @product_list = Product.where('products.name ILIKE ?', "%#{search_params[:name]}%")
    end
    if search_params.dig(:price, :min)
      @product_list = @product_list.where("price > ?", search_params[:price][:min])
    end


    if search_params.dig(:price, :max)
      @product_list = @product_list.where("price <= ?", search_params[:price][:max])
    end

    render json: { products: @product_list }
  end

  private

  def search_params
    params.require(:search_by).permit(:name, :price => {})
  end
end
