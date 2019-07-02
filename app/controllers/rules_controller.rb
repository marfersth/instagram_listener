class RulesController < ApplicationController

  def create
    @rule = Rule.create!(rule_params)
    #schedule job para escuchar de instagram (hacerlo con un cron??)
    render 'show', formats: [:json]
  end

  def update
    @rule = Rule.find(params[:id])
    @rule.update!(rule_params)
    #si se cambia el atributo 'active' reactivar/pausar la campaña (matar todos los jobs que esten para correr)
    render 'show', formats: [:json]
  end

  private

  def rule_params
    params.require(:rule).permit(
      :top_media_active, :user_id, :access_token, :campaign_id, :active, hashtags: [], users: [], words: []
    )
  end
end