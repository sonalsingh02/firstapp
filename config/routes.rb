Rails.application.routes.draw do
  get 'contacts/new'

  get 'contacts/create'

  get 'contacts/create'
  get 'contacts/new'
  get 'home/gallery'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'home#index'
  devise_for :users, controllers: {registrations: 'registrations'}
  resources "contacts", only: [:new, :create]
  #config/routes.rb
  #devise_for :users, :controllers => { :registrations => "registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
