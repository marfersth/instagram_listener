source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'active_interaction', '~> 3.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use Puma as the app server
gem 'puma', '~> 3.12'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'faraday', '~> 0.15.4'
gem 'jbuilder', '~> 2.9.1'
gem 'kaminari-mongoid', '~> 1.0.1'
gem 'mongo', '2.8.0'
gem 'mongoid', '~> 7.0.2'
gem 'rails_admin', '~> 1.4.3'
gem 'sentry-raven', '~> 2.11.0'
gem 'sidekiq-scheduler', '~> 3.0.0'

gem 'flimper_poncho', '~> 0.1.4'
gem 'health_check', '~> 3.0'
gem 'sidekiq', '~> 5.2.5'
gem 'sidekiq-cron', '~> 1.1.0'
gem 'sidekiq-failures', '~> 1.0.0'
gem 'sidekiq-unique-jobs', '~> 6.0.13'
gem 'httparty', '~> 0.17.1'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring', '~> 2.1.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7.1'
  gem 'factory_bot_rails', '~> 5.0.1'
  gem 'mongoid-rspec', '~> 4.0.1'
  gem 'rspec-json_expectations', '~> 2.2.0'
  gem 'rspec-mocks', '~> 3.8.1'
  gem 'rspec-rails', '~> 3.8.2'
  gem 'rubocop-rails', '~>2.3.2'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.5.1'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
