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
  #config/routes.rb
  #devise_for :users, :controllers => { :registrations => "registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
