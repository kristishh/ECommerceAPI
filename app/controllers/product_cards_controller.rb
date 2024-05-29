class ProductCardsController < ApplicationController
  def generate_new
    render json: product_card_service.generate_card(generate_new_params)
  end

  def verify
    card = ProductCard.find_by(user_id: @current_user.id, product_id: verify_card_params[:product_id])
    if card.present?
      render json: product_card_service.verify_card(verify_card_params[:pin_code], verify_card_params[:activation_code], verify_card_params[:product_id])
    else
      render json: { message: "Such card doesn't exist" }, status: :unprocessable_entity
    end
  end

  def cancel
    product_card = ProductCard.find(params[:id])

    return render json: { message: "Product card doesn't exist" }, status: :unprocessable_entity unless product_card.present?

    return render json: { message: "Product card doesn't belong to this user" }, status: :forbidden unless product_card.user_id == current_user.id
    
    product_card.update!(status: "cancelled")

    render json: product_card
  end

  private

  def generate_new_params
    params.require(:card).permit(:product_id, :quantity)
  end

  def verify_card_params
    params.require(:card).permit(:activation_code, :pin_code, :product_id)
    
  end

  def product_card_service
    ProductCardService.new(current_user)
  end
end
