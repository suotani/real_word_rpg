Rails.application.routes.draw do

  root to: "dashboard#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  # ダッシュボードルート
  get 'dashboard', to: 'dashboard#index'

  resources :charactors, only: [:index, :show, :create] do
    resources :charactor_tickets
    resources :tickets
  end
  resources :experience_logs, only: [:create]
  resources :experiences
  resources :shops, only: [:index, :create]

  namespace :htmladmin do
    root to: "managed_htmls#index"
    resources :sources, only: [:edit, :update]
    resources :managed_htmls
  end

  namespace :store do
    root to: "dashboard#index"
    get 'dashboard', to: 'dashboard#index'
    resources :towns, only: [:index, :new, :create] do
      get 'join_request', on: :collection
      post 'join', on: :collection
    end
    resources :stores, only: [:index, :new, :create, :edit, :update]
    resources :items, only: [:index, :new, :create, :edit, :update, :show]
    resources :stocks, only: [:index, :create]
    resources :store_actions do
      post 'buy', on: :collection
      post 'sell', on: :collection
    end
  end

end
