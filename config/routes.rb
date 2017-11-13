Rails.application.routes.draw do
  root 'home#index'

  resources :admins, only: :index
  resources :companies, except: :destroy
  resources :sellers
  resources :bookings, only: [:index, :new, :create, :destroy] do
    get 'archive', on: :collection
  end

  resources :seller_bookings, only: [:index, :destroy, :create]

  resources :booking_periods
  resources :places
  resources :time_slots

  resources :settings, only: [:index, :edit, :update]

  get '/administrera'        => 'admin_auth#new'
  post '/administrera'       => 'admin_auth#create'
  get '/administrera_logout' => 'admin_auth#destroy'

  # SAML auth for sellers
  get '/saml/login'    => 'seller_auth#login'
  get '/saml/logout'   => 'seller_auth#logout'
  post '/saml/consume' => 'seller_auth#consume'
  get '/saml/consume'  => 'seller_auth#consume'
  get '/saml/metadata' => 'seller_auth#metadata'

  match '*path', via: :all, to: 'errors#not_found'
end
