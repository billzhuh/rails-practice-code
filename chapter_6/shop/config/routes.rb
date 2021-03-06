Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Authentication
  devise_for :users

  # General

  # Resources
  resources :products do
    resources :variants, shallow: true
    collection do
      get :top
    end
    member do
      get :buy
    end
  end

  # Profile
  resource :profile, only: [:show, :edit, :update]

  # Admin
  namespace :admin do
    root "home#index"
    resources :products do
      resources :variants
    end
  end

  # Comments
  concern :commentable do
    resources :comments
  end

  resources :messages, concerns: :commentable
  resources :articles, concerns: :commentable


  # Root
  root 'products#index'
end
