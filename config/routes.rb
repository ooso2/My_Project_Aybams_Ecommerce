Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  # Public pages
  get "about",   to: "pages#about"
  get "contact", to: "pages#contact"

  # Catalog
  resources :products,   only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :orders, only: [:index, :show]

  # Checkout
  resource :checkout, only: [:show, :create]

  # Cart
  get    "cart",         to: "carts#show",   as: :cart
  post   "cart/add",     to: "carts#add",    as: :cart_add
  patch  "cart/update",  to: "carts#update", as: :cart_update
  delete "cart/remove",  to: "carts#remove", as: :cart_remove
  delete "cart/clear",   to: "carts#clear",  as: :cart_clear

  # Admin area
  namespace :admin do
    root to: "admin#dashboard", as: :root
    get "dashboard", to: "admin#dashboard", as: :dashboard
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :edit, :update]
    resources :pages
  end
end