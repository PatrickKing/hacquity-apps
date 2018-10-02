Rails.application.routes.draw do


  # Routes for the common pages and users:

  root to: 'common_pages#main'

  get '/dashboard', to: 'common_pages#dashboard'

  devise_for :users, path: 'users', controllers: {
    confirmations: 'users/confirmations',
    # omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks',
  }

  devise_for :admins, path: 'admins', controllers: {
    confirmations: 'admins/confirmations',
    # omniauth_callbacks: 'admins/omniauth_callbacks',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations',
    sessions: 'admins/sessions',
    unlocks: 'admins/unlocks',
  }

  # Since the registrations module is disabled for admins, we need this workaround to enable the stock devise edit password form.
  # Why is editing your password is tied to being able to sign up for an account? Because the devise crew has drunk the RESTful kool-aid and stuck two unrelated processes on the same resource!
  # See: https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-password#solution-2

  as :admin do
    get 'admin/edit' => 'admins/registrations#edit', :as => 'edit_admin_registration'
    patch 'admins' => 'admins/registrations#update', :as => 'admin_registration'
  end



  resource :user, only: [:show, :edit, :update] do
    post 'activate_second_shift'
    post 'activate_mentor_match'
    get 'unsubscribe'

    post 'set_email_subscription'
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
      only: [:index, :create],
      controller: 'second_shift_connection_requests',
      as: 'ss_connection_requests' do
        member do
          post 'initiator_withdraw'
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
        post 'query'
      end
      member do
        get 'cv'
      end
    end
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


  scope 'trusted-vendors' do
    resources :vendor_reviews, path: 'reviews' do
      collection do
        get 'mine'
        get 'search'
        post 'query'
      end
      member do
        post 'like'
        post 'unlike'
        post 'neutral_helpfulness'
      end
    end
  end

  scope 'cv-catalogue' do
    resource :my_cv, only: [:edit] do
      post 'update_cv'
      post 'update_cv_email'
      post 'resend_cv_email'
    end

    resources :cvs, only: [:index, :show] do
      collection do
        post 'query'
      end
    end

  end

  scope 'administration' do
    get '/dashboard', to: 'admin_pages#dashboard', as: 'admin_dashboard'

    resources :users, controller: 'admin_users', as: 'admin_users', only: [:new, :create] do

      collection do
        get 'approve_index'
        get 'disable_index'
      end

      post 'approve'
      post 'disable'
      post 'reenable'
    end

    resources :cvs, controller: 'admin_cvs', as: 'admin_cvs', only: [:index, :edit, :update]

    resources :bulk_update_record, controller: 'admin_bulk_update_record', as: 'bulk_cv', only: [:index, :new, :create, :show] do
      member do
        post :retry
      end
    end

  end


end
