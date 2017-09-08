Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'contacts/new'

  get 'contacts/create'

  get 'contacts/create'
  get 'contacts/new'
  #get 'home/gallery'
  
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  root to: 'home#index'
  devise_for :users, controllers: {registrations: 'registrations'}
  resources "contacts", only: [:new, :create]
  resources :users do
    resources :galleries do
      collection do
        get :check_name
        get :import_csv_form
        post :import
      end
    end
  end

  namespace :api do
      namespace :v1 do
        resources :gallery_pictures, only: [] do
          collection do
            post :upload
          end
          member do
            get :retrieve
          end
        end
        resources :contacts, only: [] do
          collection do
            post :send_message
          end
        end
        resources :users, only: [] do
          collection do
            post :create_user
          end
        end
      end
  end

  match "*path", to: "api/v1/errors#routing", via: :all

end