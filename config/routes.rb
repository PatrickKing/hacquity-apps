Rails.application.routes.draw do


  # Routes for the common pages and users:

  root to: 'common_pages#main'

  get '/dashboard', to: 'common_pages#dashboard'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resource :user, only: [] do
    post 'activate_second_shift'
    post 'activate_mentor_match'
  end



  # Routes for Second Shift:

  get '/second-shift', to: 'second_shift_pages#main'

  scope 'second-shift' do
    resources :service_postings, path: 'postings', except: [:index, :destroy] do
      collection do
        get 'mine'
        get 'available'
        get 'wanted'
        get 'search'
      end
      member do
        post 'open'
        post 'close'
      end
    end
    resources :connection_requests, 
      only: [:index, :create],
      controller: 'second_shift_connection_requests',
      as: 'ss_connection_requests' do
        member do
          post 'initiator_withdraw'
          post 'initiator_undo_withdraw'
          post 'receiver_accept'
          post 'receiver_decline'
        end
      end
  end


  # Routes for Mentor Match:

  get '/mentor-match', to: 'mentor_match_pages#main'
  
  scope 'mentor-match' do
    resource :my_mentor_match_profile
    resources :mentor_match_profiles, only: :show
    resources :connection_requests,
      only: [:index, :create],
      controller: 'mentor_match_connection_requests',
      as: 'mm_connection_requests' do
        member do
          post 'initiator_withdraw'
          post 'initiator_undo_withdraw'
          post 'receiver_accept'
          post 'receiver_decline'
        end
      end
  end


end
