Rails.application.routes.draw do
  root 'home#index'

  resources :seller_accounts
  resources :admin_accounts, only: :index
  resources :bookings
  resources :places

  get '/administrera'        => 'admin_auth#new'
  post '/administrera'       => 'admin_auth#create'
  get '/administrera_logout' => 'admin_auth#destroy'
s
  # SAML auth for sellers
  namespace :seller do
    get  :login
    get  :logout
    post :consume
    get  :consume
    get  :metadata
  end

  match '*path', via: :all, to: 'errors#not_found'
end
