Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#main'

  get '/dashboard', to: 'pages#dashboard'

end
