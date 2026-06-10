Rails.application.routes.draw do

  root to: "dashboard#index"

  namespace :api do
    namespace :batches do
      post 'virtual_purchase', to: 'virtual_purchases#create'
    end
  end

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
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
      get  'join_request', on: :collection
      get  'select',       on: :collection
      post 'join',         on: :collection
      post 'switch',       on: :collection
      get  'market',       on: :member
    end
    resources :stores, only: [:index, :show, :new, :create, :edit, :update] do
      resources :stocks, only: [:index, :create, :show, :edit, :update, :destroy] do
        member do
          get  :list
          post :list
          post :unlist
        end
      end
      resources :recipes, only: [:index, :new, :create, :destroy] do
        post 'craft', on: :member
      end
    end
    get 'guide',           to: 'guide#index'
    get 'shopping_street', to: 'shopping_street#index'
    resource  :bank, only: [:show] do
      post :borrow
      post :repay
    end
    resources :item_sub_categories, only: [:index, :new, :create]
    resources :item_categories,     only: [:index, :new, :create, :edit, :update, :destroy]
    resources :store_categories,    only: [:index, :new, :create, :edit, :update, :destroy] do
      post :assign_item_category,  on: :member
      post :unlink_item_category,  on: :member
    end
    get 'other_stores', to: 'other_stores#index'
    resources :store_actions, only: [] do
      get  'buy',      on: :collection
      post 'buy',      on: :collection
      get  'purchase', on: :collection
      post 'purchase', on: :collection
      post 'sell',     on: :collection
    end
  end

end
