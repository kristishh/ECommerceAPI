class OrdersController < ApplicationController
  wrap_parameters :order, include: [:product_card_id, :pin_code, :quantity]


  def create
    product_card = ProductCard.find(order_params[:product_card_id])

    return render json: { message: "Wrong pin code"}, status: :unauthorized unless product_card.authenticated?(order_params[:pin_code])

    return render json: { message: "Card doesn't belong to this user"}, status: :forbidden unless product_card.user_id == current_user.id

    new_order = Order.new(order_params.slice(:product_card_id, :quantity))

    if new_order.save
      render json: new_order, status: :created
    else
      render json: new_order.errors, status: :unprocessable_entity
    end
  end

  def index
    @all_orders = Order.joins(:product_card)
      .where(product_card: { user_id: current_user.id })
      .where.not(product_card: { status: "cancelled" })
      .order(status: :desc)
  end

  private

  def order_params
    params.require(:order).permit(:product_card_id, :pin_code, :quantity)
  end
end
