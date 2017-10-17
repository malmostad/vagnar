Rails.application.routes.draw do
  root 'home#index'

  resources :seller_accounts
  resources :admin_accounts, only: :index
  resources :bookings

  get '/administrera'        => 'admin_session#new'
  post '/administrera'       => 'admin_session#create'
  get '/administrera_logout' => 'admin_session#destroy'

  namespace :saml do
    get  :login
    get  :logout
    post :consume
    get  :consume
    get  :metadata
  end

  match '*path', via: :all, to: 'errors#not_found'
end
