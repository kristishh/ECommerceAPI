class ProductCardService
  class InvalidCredentials < StandardError; end
  class AccessDenied < StandardError; end
  

  def initialize(current_user)
    @current_user = current_user
  end

  def generate_card(details)
    product = Product.find(details[:product_id])

    raise "Product is inactive" unless product.inactive?

    ProductCard.create!(user_id: @current_user.id, **details)
  end

  def verify_card(pin_code, activation_code, product_id)
    card = ProductCard.find_by(user_id: @current_user.id, product_id: product_id)

    raise AccessDenied unless card.user_id == @current_user.id
    
    raise InvalidCredentials unless card.authenticated?(pin_code)

    if !card.verified?(activation_code)
      raise InvalidCredentials
    else
      card.update!(status: "verified")
      card
    end
  end
end