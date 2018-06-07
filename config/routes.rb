Rails.application.routes.draw do

  resource :my_mentor_match_profile

  resources :mentor_match_profiles, only: :show

  resources :service_postings, except: :index

  devise_for :users

  root to: 'common_pages#main'

  get '/dashboard', to: 'common_pages#dashboard'

  get '/second-shift', to: 'second_shift_pages#main'
  get '/mentor-match', to: 'mentor_match_pages#main'

  resource :user, only: [] do
    post 'activate_second_shift'
    post 'activate_mentor_match'
  end

end
