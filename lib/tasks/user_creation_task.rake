namespace :setup_accounts do
  desc "Create a client and an admin"
  task user_creation: [:environment] do
    User.create!(email: "admin@gmail.com", password: "password", role: 1)
    User.create!(email: "client@gmail.com", password: "password")
  end
end
