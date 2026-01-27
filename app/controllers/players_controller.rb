class PlayersController < ApplicationController
  def show
    service = ApiFootballService.new
    
    # 自分のデータ（1時間キャッシュ）
    @player_data = Rails.cache.fetch("player_stats_#{params[:id]}", expires_in: 1.hour) do
      service.fetch_player_stats(params[:id])
    end

    if @player_data && (team_id = @player_data.dig('statistics', 0, 'team', 'id'))
      # チームメイト一覧（1時間キャッシュ）
      all_players = Rails.cache.fetch("team_squad_#{team_id}", expires_in: 1.hour) do
        service.fetch_squad(team_id) || []
      end
      
      @team_players = all_players.select { |p| p['id'].present? && p['name'].present? }
                                 .reject { |p| p['id'].to_s == params[:id].to_s }

      # 比較相手のデータ（1時間キャッシュ）
      if params[:compare_id].present?
        @compare_player_data = Rails.cache.fetch("player_stats_#{params[:compare_id]}", expires_in: 1.hour) do
          service.fetch_player_stats(params[:compare_id])
        end
      end
    else
      @team_players = []
    end
  end
end