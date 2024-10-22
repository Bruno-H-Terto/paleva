Rails.application.routes.draw do
  devise_for :restaurant_owners, controllers: {
    sessions: 'restaurant_owners/sessions',
    registrations: 'restaurant_owners/registrations'
  }

  root 'home#index'

  resources :restaurants, only: %i[new create show]
end
