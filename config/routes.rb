Rails.application.routes.draw do

  root to: "charactors#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :charactors, only: [:index, :show, :create] do
    resources :charactor_tickets
  end
  resources :experience_logs, only: [:create]
  resources :experiences, only: [:new, :create]
  resources :vrs
  resources :tickets

  namespace :admin do
    resources :skills
  end

  namespace :htmladmin do
    root to: "users#index"
    resources :managed_htmls do
      member do
        get :edit_source
        post :update_source
      end
      collection do
        get :editor_trial
        post :create_for_yaml
      end
    end

    resources :users

  end

end
