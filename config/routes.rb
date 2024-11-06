Rails.application.routes.draw do
  root 'restaurants#overview'

  devise_for :owners, controllers: {registrations: "registrations"}

  resource :restaurant, only: [:show, :new, :create] do
    resources :schedules, only: [:new, :create]
    resource :schedules, only: [:edit, :update]
  end
  resolve('Restaurant') { [:restaurant] }

  get '/search', to: "restaurants#search"

  resources :dishes, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :portions, only: [:new, :create]
    patch 'deactivate', on: :member
    patch 'activate', on: :member
  end

  resources :drinks, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :portions, only: [:new, :create]
    patch 'deactivate', on: :member
    patch 'activate', on: :member
  end

  resources :portions, only: [:edit, :update]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
