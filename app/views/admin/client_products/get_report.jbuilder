if @get_report_params.has_key?(:product_id)
  json.product @report_by_product.first.product
  json.brand @report_by_product.first.product.brand
  json.user_availability_list @report_by_product.collect(&:user)
else
  json.user @report_by_user.first.user

  json.avaiable_products @report_by_user.each do |p|
    json.product p.product
    json.brand p.product.brand
  end
end
