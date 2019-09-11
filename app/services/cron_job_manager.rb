class CronJobManager
  attr_accessor :rule, :cron_jobs
  HASHTAG_SEARCH_TIME = '*/15 * * * *'.freeze

  def initialize(rule)
    @rule = rule
    @cron_jobs = generate_cron_jobs
  end

  def enable
    change_status('enable!')
  end

  def disable
    change_status('disable!')
    delete_scheduled_jobs # Remove campaign's scheduled non-cron jobs
  end

  def change_status(status)
    job_names.each do |job|
      Sidekiq::Cron::Job.find(job).try(:send, status)
    end
  end

  def job_names
    @cron_jobs.keys.map { |job| job_name(job) }
  end

  def job_name(job_class)
    "#{job_class}-#{rule.id}"
  end

  def create_jobs
    # Cron notation is used, for eg */2 * * * * means the job will run every 2 minutes
    # The mininum cron setting is one minute.
    cron_jobs.each do |job, settings|
      create_job(job, settings)
    end
  end

  def create_job(job_class, settings)
    return if enabled_job_already_exists?(job_class)

    Sidekiq::Cron::Job.create(name: job_name(job_class),
                              cron: settings['cron'], class: job_class.to_s,
                              args: rule.id, queue: settings['queue'])
  end

  def enabled_job_already_exists?(job_class)
    job = Sidekiq::Cron::Job.find job_name(job_class)
    job.present?
  end

  def delete_jobs
    job_names.each do |job|
      Sidekiq::Cron::Job.find(job).try(:destroy)
    end
    delete_scheduled_jobs # Remove campaign's scheduled non-cron jobs
  end

  private

  def generate_cron_jobs
    cron_jobs = {}
    cron_jobs[:InstagramHashtagSearchJob] = instagram_hashtag_search_cron
    cron_jobs.with_indifferent_access
  end

  def instagram_hashtag_search_cron
    { queue: 'instagram_hashtag_search', cron: HASHTAG_SEARCH_TIME }
  end

  def delete_scheduled_jobs
    find_jobs.map(&:delete)
  end

  def find_jobs
    Sidekiq::ScheduledSet.new.select do |j|
      j.args.any? do |arg|
        arg['arguments'].any? { |a| id_from_argument(a) == rule.id }
      end
    end
  end

  def id_from_argument(argument)
    return -1 unless argument.is_a?(Hash)

    argument['_aj_globalid'].split('/').last.to_i if argument.dig('_aj_globalid').present?
  end
end
