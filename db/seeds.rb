# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users_list = [
  { email: "admin@gmail.com", password: "password", role: "admin", payout_rate: 1 },
  { email: "client1@gmail.com", password: "password", payout_rate: 23},
  { email: "client2@gmail.com", password: "password", payout_rate: 15}
]

users_list.each do |user|
  new_user = User.create!(email: user[:email], password: user[:password], role: user[:role], payout_rate: user[:payout_rate])
end

brands_list = [
  { name: "Example brand name 1", description: "Lorem ipsum 1", status: "active" },
  { name: "Example brand name 2", description: "Lorem ipsum 2", status: "active" },
  { name: "Example brand name 3", description: "Lorem ipsum 3", status: "active" },
  { name: "Example brand name 4", description: "Lorem ipsum 4", status: "active" },
  { name: "Example brand name 5", description: "Lorem ipsum 5", status: "active" },
]

brands_list.each do |brand|
  Brand.find_or_create_by(name: brand[:name], description: brand[:description], status: brand[:status])
end

products_list = [
  { name: "Example product name 1", description: "Lorem ipsum 1", status: "active", price: 30.99, brand_name: "Example brand name 1"},
  { name: "Example product name 2", description: "Lorem ipsum 2", status: "active", price: 50.49, brand_name: "Example brand name 1" },
  { name: "Example product name 3", description: "Lorem ipsum 3", status: "active", price: 60, brand_name: "Example brand name 1" },
  { name: "Example product name 4", description: "Lorem ipsum 4", status: "active", price: 45.22, brand_name: "Example brand name 2" },
  { name: "Example product name 5", description: "Lorem ipsum 5", status: "active", price: 45.99, brand_name: "Example brand name 3" },
  { name: "Example product name 6", description: "Lorem ipsum 6", status: "active", price: 45.99, brand_name: "Example brand name 3" },
  { name: "Example product name 7", description: "Lorem ipsum 7", status: "active", price: 100, brand_name: "Example brand name 4" },
  { name: "Example product name 8", description: "Lorem ipsum 8", status: "active", price: 199.99, brand_name: "Example brand name 5" },
  { name: "Example product name 9", description: "Lorem ipsum 9", status: "active", price: 24.99, brand_name: "Example brand name 5" },
  { name: "Example product name 10", description: "Lorem ipsum 10", status: "active", price: 30, brand_name: "Example brand name 5" }
]

products_list.each do |product|
  brand = Brand.find_by(name: product[:brand_name])
  Product.find_or_create_by(name: product[:name], description: product[:description], status: product[:status], price: product[:price], brand: brand)
end

client_product_list = [
  { product_name: "Example product name 1", user_email: "client1@gmail.com" },
  { product_name: "Example product name 2", user_email: "client1@gmail.com" },
  { product_name: "Example product name 3", user_email: "client1@gmail.com" },
  { product_name: "Example product name 4", user_email: "client1@gmail.com" },
  { product_name: "Example product name 5", user_email: "client1@gmail.com" },
  { product_name: "Example product name 6", user_email: "client1@gmail.com" },
  { product_name: "Example product name 9", user_email: "client1@gmail.com" },
  { product_name: "Example product name 10", user_email: "client1@gmail.com" },
  { product_name: "Example product name 10", user_email: "client1@gmail.com" },
  { product_name: "Example product name 1", user_email: "client2@gmail.com" },
  { product_name: "Example product name 2", user_email: "client2@gmail.com" },
  { product_name: "Example product name 8", user_email: "client2@gmail.com" },
  { product_name: "Example product name 9", user_email: "client2@gmail.com" }
]

client_product_list.each do |client_product|
  client = User.find_by(email: client_product[:user_email])
  product = Product.find_by(name: client_product[:product_name])

  ClientProduct.find_or_create_by(user: client, product: product)
end


product_cards = [
  { client_email: "client1@gmail.com", prouct_name: "Example product name 1", quantity: 50 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 2", quantity: 30 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 3", quantity: 20 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 4", quantity: 80 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 5", quantity: 10 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 6", quantity: 150 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 9", quantity: 90 },
  { client_email: "client1@gmail.com", prouct_name: "Example product name 10", quantity: 96 },
  { client_email: "client2@gmail.com", prouct_name: "Example product name 1", quantity: 60 },
  { client_email: "client2@gmail.com", prouct_name: "Example product name 2", quantity: 10 },
  { client_email: "client2@gmail.com", prouct_name: "Example product name 8", quantity: 150 },
  { client_email: "client2@gmail.com", prouct_name: "Example product name 9", quantity: 150 }
]

product_cards.each do |product_card|
  client = User.find_by(email: product_card[:client_email])
  product = Product.find_by(name: product_card[:prouct_name])

  product_card = ProductCard.create!(product: product, user: client, quantity: product_card[:quantity])
end



cancel_brands = [
  { brand_name: "Example brand name 4" },
  { brand_name: "Example brand name 5" },
]

cancel_brands.each do |brand|
  Brand.find_or_create_by(name: brand[:brand_name]).update!(status: "inactive")
end


orders_list = [
  { client_name: "client1@gmail.com", product_name: "Example product name 2", quantity: 20 },
  { client_name: "client1@gmail.com", product_name: "Example product name 2", quantity: 10 },
  { client_name: "client2@gmail.com", product_name: "Example product name 1", quantity: 10 },
]

orders_list.each do |order|
  client = User.find_by(email: order[:client_name])
  product = Product.find_by(name: order[:product_name])

  product_card = ProductCard.find_by(user: client, product: product)
  product_card&.update!(status: "verified")

  Order.create!(product_card: product_card, quantity: order[:quantity])
end
