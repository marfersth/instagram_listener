Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :rules, only: %i[create update destroy]
end
