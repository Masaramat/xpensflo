Rails.application.routes.draw do  
  require 'sidekiq/web'
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :requests do
    get 'daily_report', on: :collection
    get 'general_reports', on: :collection
    member do
      get 'vet_request'
      get 'approve_request'
      get 'clear_request'
      post 'pay_request'
      post 'finish_request'      
    end

  end
  root "home#index"
  namespace :admin do
    resources :departments
    resources :branches
    resources :users
    resources :accounts
  end
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
