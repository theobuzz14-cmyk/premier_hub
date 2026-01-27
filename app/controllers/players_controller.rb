class PlayersController < ApplicationController
  def show
    service = ApiFootballService.new
    # キャッシュを介してAPIデータを取得
    @player_data = service.fetch_player_stats(params[:id])

    if @player_data.nil?
      redirect_to root_path, alert: "選手データが見つかりませんでした。"
    end
  end
end
