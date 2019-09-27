class RulesController < ApplicationController
  def create
    return head :ok unless rule_params[:active]

    @rule = Rule.create!(rule_params)
    CronJobManager.new(@rule).create_jobs
    render 'show', formats: [:json]
  end

  def update
    @rule = Rule.find_by(flimper_back_rule_id: params[:id])
    @rule.update!(rule_params)
    if @rule.active
      CronJobManager.new(@rule).enable
    else
      CronJobManager.new(@rule).disable
    end
    render 'show', formats: [:json]
  end

  def destroy
    @rule = Rule.find_by(flimper_back_rule_id: params[:id])
    return render json: { error: "not found rule id: #{params[:id]}" }, status: :not_found if @rule.blank?

    @rule.delete
    CronJobManager.new(@rule).delete_jobs
    render json: { info: 'deleted' }, status: :ok
  end

  private

  def rule_params
    params.require(:rule).permit(:user_id,
                                 :access_token,
                                 :campaign_id,
                                 :active,
                                 :flimper_back_rule_id,
                                 hashtags: [],
                                 users: [],
                                 words: [])
  end
end
