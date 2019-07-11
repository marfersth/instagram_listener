class RulesController < ApplicationController

  def create
    @rule = Rule.create!(rule_params.merge(active: true))
    CronJobManager.new(@rule).create_jobs
    render 'show', formats: [:json]
  end

  def update
    @rule = Rule.find(params[:id])
    @rule.update!(rule_params)
    if @rule.active
      CronJobManager.new(@rule).enable
    else
      CronJobManager.new(@rule).disable
    end
    render 'show', formats: [:json]
  end

  def destroy
    @rule = Rule.find(params[:id])
    CronJobManager.new(@rule).delete_jobs
    render status: :ok
  end

  private

  def rule_params
    params.require(:rule).permit(
        :user_id, :access_token, :campaign_id, :active, hashtags: [], users: [], words: []
    )
  end
end
