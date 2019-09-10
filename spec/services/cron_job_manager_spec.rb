require 'rails_helper'

describe CronJobManager do
  let(:rule) { create :rule }
  let(:instance) { CronJobManager.new(rule) }
  let(:job_name) { "InstagramHashtagSearchJob-#{rule.id}" }

  context '#create_hashtag_job' do
    it 'job not exists' do
      expect(Sidekiq::Cron::Job).to receive(:find).with(job_name).and_return(false)
      expect(Sidekiq::Cron::Job).to receive(:create)
        .with(name: job_name,
              cron: '*/15 * * * *',
              class: 'InstagramHashtagSearchJob',
              args: rule.id,
              queue: 'instagram_hashtag_search')
      instance.create_jobs
    end
    it 'job already exists' do
      expect(Sidekiq::Cron::Job).to receive(:find).with(job_name).and_return(true)
      expect(Sidekiq::Cron::Job).not_to receive(:create)
      instance.create_jobs
    end
  end
end
