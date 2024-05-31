json.all_card_orders do
  json.array! @all_orders do |order|
  json.product_card_status order.product_card.status
  json.product_card_current_quantity order.product_card.quantity
  json.product_name order.product_card.product.name
  json.product_brand_name order.product_card.product.brand.name
  json.payout_rate number_with_precision(order.product_card.user.payout_rate, precision: 2)
  json.total_payout_rate number_with_precision(order.product_card.user.payout_rate * order.quantity, precision: 2)

  json.extract! order,
    :id,
    :product_card_id,
    :quantity,
    :status

  end
end