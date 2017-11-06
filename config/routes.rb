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
  namespace :seller_auth do
    get  :login
    get  :logout
    post :consume
    get  :consume
    get  :metadata
  end

  match '*path', via: :all, to: 'errors#not_found'
end
