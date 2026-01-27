class PlayersController < ApplicationController
  def show
    service = ApiFootballService.new
    # 1. 自身のスタッツを取得
    @player_data = service.fetch_player_stats(params[:id])
    
    if @player_data
      team_id = @player_data.dig('statistics', 0, 'team', 'id')
      # 2. 比較対象を選べるように同じチームの全選手リストを取得
      @team_squad = service.fetch_squad(team_id)
      
      # 3. 比較対象(compare_id)が指定されていれば、その選手のスタッツも取得
      if params[:compare_id].present?
        @compare_player_data = service.fetch_player_stats(params[:compare_id])
      end
    else
      redirect_to root_path, alert: "選手データが見つかりませんでした。"
    end
  end
end