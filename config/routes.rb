Rails.application.routes.draw do
  resources :service_postings, except: :index
  devise_for :users

  root to: 'pages#main'

  get '/dashboard', to: 'pages#dashboard'

end
