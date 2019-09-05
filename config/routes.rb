Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  # mount RailsAdmin::Engine => '/', as: 'rails_admin'
  
  get '/webhooks', to: 'webhooks#validation'

  post 'webhooks', to: 'webhooks#event'

  resources :rules, only: %i[create update destroy]


end
