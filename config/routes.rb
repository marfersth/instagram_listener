Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount RailsAdmin::Engine => '/', as: 'rails_admin'

  resources :rules, only: %i[create update destroy]
end
