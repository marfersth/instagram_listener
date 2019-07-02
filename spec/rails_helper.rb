# frozen_string_literal: true

require 'spec_helper'

require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'mongoid'
require 'sidekiq/testing'

Mongoid.load!('./config/mongoid.yml')

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include(FactoryBot::Syntax::Methods)
  config.include(Mongoid::Matchers)

  config.before(:each) do
    Mongoid.purge!
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end

Sidekiq::Testing.fake!
