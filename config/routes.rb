Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  resources :merchants

  resources :items, only: [:index, :show, :edit, :update]

  resources :merchants, only: [] do
    resources :items, only: [:index], :controller => "items"
  end

  resources :items, only: [] do
    resources :reviews, only: [:new, :create], :controller => "reviews"
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  post "/cart", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :show]

  resources :users, only: [:new, :create], path: "register"
  resource :profile, only: [:edit, :update, :show], :controller => "users"

  resource :password, only: [:edit, :update], :controller => "password"

  controller :sessions do
   get 'login' => :new
   post 'login' => :create
   delete 'logout' => :destroy
  end

  scope '/profile' do
    resources :orders, only: [:index, :show, :destroy], :controller => 'user_orders'
  end

  get "/merchant", to: "merchant/dashboard#show"

  post "merchant/items/:item_id", to: "merchant/items#activate_deactivate_item"

  patch "merchant/orders/:order_id/item_order/:item_order_id", to: "merchant/orders#fulfill"

  get "/merchant/discounts", to: "merchant/discounts#index", as: "merchant_discounts"
  post "/merchant/discounts", to: "merchant/discounts#create"
  get "/merchant/discounts/new", to: "merchant/discounts#new", as: "new_merchant_discount"
  get "/merchant/discounts/:id/edit", to: "merchant/discounts#edit", as: "edit_merchant_discount"
  get "/merchant/discounts/:id", to: "merchant/discounts#show", as: "merchant_discount"
  patch "/merchant/discounts/:id", to: "merchant/discounts#update"
  delete "/merchant/discounts/:id", to: "merchant/discounts#destroy"

  get "/merchant/items", to: "merchant/items#index"
  post "/merchant/items", to: "merchant/items#create"
  get "/merchant/items/new", to: "merchant/items#new", as: "new_merchant_item"
  get "/merchant/items/:id/edit", to: "merchant/items#edit", as: "edit_merchant_item"
  get "/merchant/items/:id", to: "merchant/items#show", as: "merchant_item"
  patch "/merchant/items/:id", to: "merchant/items#update"
  delete "/merchant/items/:id", to: "merchant/items#destroy"

  get "/merchant/orders/:id", to: "merchant/orders#show"

  get "/admin", to: "admin/dashboard#index"
  patch "/admin/orders/:order_id", to: "admin/dashboard#update"

  get "/admin/users", to: "admin/users#index"
  get "/admin/users/:id", to: "admin/users#show"

  get "/admin/merchants/:merchant_id", to: "admin/merchants#show"
  get "/admin/merchants", to: "admin/merchants#index"
  patch "/admin/merchants/:merchant_id", to: "admin/merchants#enable_disable_merchant"
end
