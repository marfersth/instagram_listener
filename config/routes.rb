Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :rules, only: %i[create update destroy]
  resources :subscriptions, only: %i[create]

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
