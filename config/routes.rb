Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  get '/webhooks', to: 'webhooks#validation'
  post '/webhooks', to: 'webhooks#event'

  get '/webhooks', to: 'webhooks#validation'
  post '/webhooks', to: 'webhooks#event'

  resources :rules, only: %i[create update destroy]
  resources :subscriptions, only: %i[create]
  resources :activity_subscriptions, only: %i[create destroy]

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: redirect('/admin')
end
