source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'mongo', '2.8.0'
gem 'mongoid', '~> 7.0.2'
gem 'kaminari-mongoid', '~> 1.0.1'
gem 'rails_admin', '~> 1.4.2'
gem 'jbuilder', '~> 2.9.1'
gem 'sidekiq-scheduler', '~> 3.0.0'
gem 'faraday', '~> 0.15.4'


gem 'sidekiq', '~> 5.2.5'
gem 'sidekiq-cron', '~> 1.1.0'
gem 'sidekiq-unique-jobs', '~> 6.0.13'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'rspec-mocks', '~> 3.8.1'
  gem 'rspec-rails', '~> 3.8.2'
  gem 'dotenv-rails', '~> 2.7.1'
  gem 'factory_bot_rails', '~> 5.0.1'
  gem 'mongoid-rspec', '~> 4.0.1'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.5.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]