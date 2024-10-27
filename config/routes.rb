Rails.application.routes.draw do
  devise_for :restaurant_owners, controllers: {
    sessions: 'restaurant_owners/sessions',
    registrations: 'restaurant_owners/registrations'
  }

  root 'home#index'

  resources :restaurants, only: %i[new create show edit update] do
    resources :address, only: %i[edit update]
    resources :business_hours, only: %i[new create edit update], on: :member
    resources :dishes, only: %i[new create show edit update destroy], on: :member
    resources :beverages, only: %i[new create show edit update destroy], on: :member
  end
end
