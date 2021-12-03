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

end
