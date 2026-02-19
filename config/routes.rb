Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  concern :localized do
    resource :session
    resources :passwords, param: :token
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.

    root "products#index"
    resources :products do
      resources :subscribers, only: [ :create ]
    end

    resource :unsubscribe, only: [ :show ]

    resources :orders do
      post :add_product, on: :member
      # izipay
      get :checkout
      post :success
    end

    get "/cart", to: "orders#show", as: :cart

    resources :order_items, only: [ :destroy ]

    # post "/checkout", to: "checkouts#create"

    # get "/success", to: "checkouts#success"
    get "/failure", to: "checkouts#failure"
    get "/pending", to: "checkouts#pending"

    # izipay
    post "/izipay_callback", to: "payments#izipay_callback"
    #
    get "/historical-overview", to: "stories#index", as: :stories
  end

  scope "(:locale)", locale: /es|en/ do
    concerns :localized
  end

  post "/webhooks/mercadopago", to: "webhooks#mercadopago"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
