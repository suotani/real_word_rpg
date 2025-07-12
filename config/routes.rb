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

  namespace :shop do
    root to: "shops#index"
    resources :towns, only: [:index, :new, :create] do
      post 'join', on: :collection
    end
    resources :shops, only: [:index, :new, :create, :edit, :update]
    resources :items, only: [:index, :new, :create, :edit, :update, :show]
    resources :stocks, only: [:index, :create]
    resources :shop_actions do
      post 'buy', on: :collection
      post 'sell', on: :collection
    end
  end

end
