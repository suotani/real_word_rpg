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

  namespace :admin do
    root to: 'resources#models'
    resources :wholesale_stocks, only: [:index, :new, :create, :edit, :update, :destroy]
    resource  :impersonation,    only: [:create, :destroy]
    get    'resources/:model_name/new',      to: 'resources#new',     as: :new_resource_record
    post   'resources/:model_name',          to: 'resources#create',  as: :resource_records
    get    'resources/:model_name/:id/edit', to: 'resources#edit',    as: :edit_resource_record
    patch  'resources/:model_name/:id',      to: 'resources#update'
    put    'resources/:model_name/:id',      to: 'resources#update'
    delete 'resources/:model_name/:id',      to: 'resources#destroy'
    get    'resources/:model_name/:id',      to: 'resources#show',    as: :resource_record
    get    'resources/:model_name',          to: 'resources#index',   as: :resource_record_list
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
    resources :sales_logs, only: [:index]
    resource  :bank, only: [:show] do
      post :borrow
      post :repay
    end
    resource  :virtual_customer_batch, only: [:show, :create]
    resources :item_sub_categories, only: [:index, :new, :create] do
      post :import_master, on: :collection
    end
    resources :item_categories,     only: [:index, :new, :create, :edit, :update, :destroy]
    resources :buisiness_times,     only: [:index]
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
