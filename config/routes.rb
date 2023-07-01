Rails.application.routes.draw do

  root to: "charactors#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :charactors, only: [:index, :show, :create] do
    resources :charactor_tickets
    resources :tickets
  end
  resources :experience_logs, only: [:create]
  resources :experiences
  resources :vrs
  resources :shops, only: [:index, :create]

  namespace :htmladmin do
    root to: "managed_htmls#index"
    resources :sources, only: [:edit, :update]
    resources :managed_htmls
  end

end
