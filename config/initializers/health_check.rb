class SidekiqHealthCheck < HealthCheck::SidekiqHealthCheck
  def self.perform_check
    error = check
    return error unless error == ''

    stats = Sidekiq::Stats.new
    return "Sidekiq: There are #{stats.enqueued} jobs enqueued" if enqueued_threshold(stats)

    ''
  end

  def self.enqueued_threshold(stats)
    stats.enqueued > ENV['HEALTH_CHECK_MAX_JOBS_ENQUEUED'].to_i
  end
end

HealthCheck.setup do |config|
  config.uri = 'health-check'
  config.standard_checks = %w[database migrations custom cache redis sidekiq-redis]
  config.full_checks = %w[database migrations custom cache redis sidekiq-redis]
  config.add_custom_check('sidekiq-redis') do
    SidekiqHealthCheck.perform_check
  end
  config.basic_auth_username = ENV['HEALTH_CHECK_USERNAME']
  config.basic_auth_password = ENV['HEALTH_CHECK_PASSWORD']
  config.redis_url = ENV[ENV.fetch('REDIS_PROVIDER', '')]
end
