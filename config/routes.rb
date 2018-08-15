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

  scope 'second-shift' do
    resources :service_postings, path: 'postings', except: [:index, :destroy] do
      collection do
        get 'mine'
        get 'available'
        get 'wanted'
      end
      member do
        post 'open'
        post 'close'
      end
    end
    resources :connection_requests, 
      only: [:index, :create, :show],
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
  
  scope 'mentor-match' do
    resource :my_mentor_match_profile, only: [:show, :edit, :update] do
      collection do
        get 'edit_cv'
        post 'update_cv'
      end
    end
    resources :mentor_match_profiles, only: [:index, :show] do
      collection do
        get 'search'
        post 'query'
      end
    end
    resources :connection_requests,
      only: [:index, :create, :show],
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
