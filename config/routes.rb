Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  devise_for :user, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }

  authenticated :user do
    root :to => 'content#show_info'
  end

  namespace :admin do
    resources 'brands', only: [:create, :update, :destroy]
    resources 'products', only: [:create, :update, :destroy]

    post 'users/create_client' => 'users/create_client'

    get 'client_products/get_report' => 'client_products#get_report'
    post 'client_products/set_availability' => 'client_products#set_availability'
  end

  get 'products/search' => 'products#search'

  post 'product_cards/generate_new' => 'product_cards/generate_new'
  put 'product_cards/verify' => 'product_cards/verify'
  delete 'product_cards/cancel/:id' => 'product_cards#cancel'

  # Defines the root path route ("/")
  # root "posts#index"
end
