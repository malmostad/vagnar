Rails.application.routes.draw do
  root 'home#index'

  resources :admins, only: :index
  resources :sellers
  resources :bookings
  resources :places

  get '/administrera'        => 'admin_auth#new'
  post '/administrera'       => 'admin_auth#create'
  get '/administrera_logout' => 'admin_auth#destroy'

  # SAML auth for sellers
  namespace :seller_auth do
    get  :login
    get  :logout
    post :consume
    get  :consume
    get  :metadata
  end

  match '*path', via: :all, to: 'errors#not_found'
end
