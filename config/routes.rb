Rails.application.routes.draw do

  resource :my_mentor_match_profile

  resources :mentor_match_profiles only: :show

  resources :service_postings, except: :index

  devise_for :users

  root to: 'pages#main'

  get '/dashboard', to: 'pages#dashboard'

end
