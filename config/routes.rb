Rails.application.routes.draw do
  root 'home#index'

  resources :seller_accounts
  resources :admin_accounts, only: :index
  resources :bookings

  get  '/admin/login'  => 'session_admin#new'
  post '/admin/login'  => 'session_admin#create'
  get  '/admin/logout' => 'session_admin#destroy'

  get  '/login'  => 'session_seller#new'
  post '/login'  => 'session_seller#create'
  get  '/logout' => 'session_seller#destroy'

  namespace :saml do
    get  :sso
    post :consume
    get  :consume # Not used
    get  :metadata
    get  :logout
  end
end
