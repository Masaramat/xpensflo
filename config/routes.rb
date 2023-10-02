Rails.application.routes.draw do 
  
  get 'debit_credits/pending_requests', to: 'debit_credits#pending_requests'
  resources :debit_credits do 
    get 'approve', on: :member
    post 'pay_debit_credit', on: :member
  end
  
  require 'sidekiq/web'
  authenticate :user, ->(user) { user.admin? } do 
    mount Sidekiq::Web => '/sidekiq'
  end  
  get '/reports/daily_reports', to: 'reports#daily_reports'
  get '/reports/daily_disbusements_report', to: 'reports#daily_disbusements_report'
  get '/reports/all_disbursements_report', to: 'reports#all_disbursements_report'

  get '/reports/daily_transfers_report', to: 'reports#daily_transfers_report'
  get '/reports/all_transfers_report', to: 'reports#all_transfers_report'

  get '/reports/ft_daily_transfers_report', to: 'reports#ft_daily_transfers_report'


  post '/reports/general_reports', to: 'reports#general_reports'
  resources :reports do 
    
  end

  
  resources :requests do
    post 'reject_request', on: :member
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
