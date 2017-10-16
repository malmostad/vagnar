Rails.application.routes.draw do
  root 'home#index'

  resources :seller_accounts
  resources :admin_accounts, only: :index
  resources :bookings

  get  '/admin/session'  => 'session_admin#new'
  post '/admin/session'  => 'session_admin#create'
  get  '/admin/logout' => 'session_admin#destroy'

  get  '/session'  => 'session_seller#new'
  post '/session'  => 'session_seller#create'
  get  '/logout' => 'session_seller#destroy'

  namespace :saml do
    get  :sso
    post :consume
    get  :consume # Not used
    get  :metadata
    get  :logout
  end
end
