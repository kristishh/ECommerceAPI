class Admin::ClientProductsController < ApplicationController
  before_action :authorize_user!
  before_action :set_client, only:  [:set_availability]

  def get_report
    return render json: { message: "Choose between user_id and product_id" }, status: :unprocessable_entity if get_report_params.has_key?(:product_id) && get_report_params.has_key?(:user_id)

    client_products = ClientProduct.joins(:user)

    if @get_report_params[:user_id].present?
      @report_by_user = client_products.where(user_id: @get_report_params[:user_id])
    else
      @report_by_product = client_products.where(product_id: @get_report_params[:product_id])
    end

    return render json: { message: "Nothing was found" } unless @report_by_user.present? || @report_by_product.present?
  end

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

  def get_report_params
    @get_report_params = params.require(:get_report_by).permit(:user_id, :product_id)
  end
end
