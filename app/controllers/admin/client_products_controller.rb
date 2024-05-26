class Admin::ClientProductsController < ApplicationController
  before_action :authorize_user!
  before_action :set_client

  def set_availability    
    product_ids = set_availability_params[:product_ids]
    
    return render json: { message: "List of products_ids is missing" }, status: :unprocessable_entity unless product_ids.present?

    old_client_product_list_ids = @client.client_products.pluck(:id)
    new_client_product_list = []
    invalid_products = []

    product_ids.each do |product_id|
      product = Product.find(product_id)
      if product
        new_client_product_list << @client.client_products.new(product_id: product.id)
      else
        invalid_products << product_id
      end
    end

    if invalid_products.any?
      render json: { message: "Products with IDs #{invalid_products.join(', ')} not found" }, status: :unprocessable_entity
    else
      # Everytime we set a new list of available products to the user
      # previously available products to the user will be removed 
      @client.client_products.where(id: old_client_product_list_ids).destroy_all

      new_client_product_list.each(&:save)

      render json: { message: "Product availability was successfully set." }
    end
  end

  private

  def set_client
    @client = User.find(set_availability_params[:user_id])
  end

  def set_availability_params
    params.require(:product_availability).permit(:user_id, :product_ids => [])
  end
end
