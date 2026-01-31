class TeamsController < ApplicationController
  def index
    @teams = Team.order(:name)
  end

  def show
    @team = Team.find(params[:id])
    @posts = @team.posts.active_user.includes(:user).order(created_at: :desc).page(params[:page]).per(10)

    @squad_data = []

    # API IDがある場合のみデータを取得
    if @team.api_team_id.present?
      begin
        service = ApiFootballService.new
        @squad = service.fetch_squad(@team.api_team_id)
      rescue => e
        logger.error "API Error: #{e.message}"
      end
    end
  end
end