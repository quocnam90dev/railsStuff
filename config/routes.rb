Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do

      resources :books, only: [:index, :create, :destroy]
      # post 'authenticate', to: 'authentication#create'

    end
  end

  scope '/api/v1' do
    resources :drinks
  end
end
