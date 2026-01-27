class ApiFootballService
  BASE_URL = 'https://v3.football.api-sports.io'

  def initialize
    @api_key = Rails.application.credentials.rapidapi[:key]
  end

  # チームのロゴとAPI上のIDを更新する
  def update_team_logos
    response = Faraday.get("#{BASE_URL}/teams") do |req|
      req.headers['x-apisports-key'] = @api_key
      req.params['league'] = '39'
      req.params['season'] = '2024'
    end

    data = JSON.parse(response.body)

    if data["response"].nil? || data["response"].empty?
      puts "APIエラー: #{data["errors"] || "データが空です"}"
      return
    end

    data["response"].each do |item|
      api_name = item["team"]["name"]
      logo_url = item["team"]["logo"]
      api_team_id = item["team"]["id"]

      # 名前が完全に一致するか、またはAPI名がDB名に含まれているか（部分一致）で探す
      # 例: APIが "Newcastle" でも DBが "Newcastle United" なら見つけられる
      team = Team.find_by(name: api_name) || 
             Team.where("name LIKE ?", "%#{api_name}%").first ||
             Team.find_by(name: "Wolverhampton Wanderers") if api_name == "Wolves" # 特殊な例

      if team
        team.update(logo_url: logo_url, api_team_id: api_team_id)
        puts "✅ Updated: #{team.name} (API Name: #{api_name}, ID: #{api_team_id})"
      else
        puts "⚠️ Not found in DB: #{api_name}"
      end
    end
  end

  # 特定の選手の詳細スタッツを取得（24時間キャッシュ）
  def fetch_player_stats(player_id)
    Rails.cache.fetch("player_stats_#{player_id}", expires_in: 24.hours) do
      response = Faraday.get("#{BASE_URL}/players") do |req|
        req.headers['x-apisports-key'] = @api_key
        req.params['id'] = player_id
        req.params['season'] = '2024'
      end

      if response.success?
        data = JSON.parse(response.body)
        data['response']&.first # 選手の詳細データ（スタッツ含む）を返す
      else
        nil
      end
    end
  end

  # チームの選手一覧（squad）を取得（24時間キャッシュ）
  def fetch_squad(team_id)
    Rails.cache.fetch("team_squad_#{team_id}", expires_in: 24.hours) do
      response = Faraday.get("#{BASE_URL}/players/squads") do |req|
        req.headers['x-apisports-key'] = @api_key
        req.params['team'] = team_id
      end

      if response.success?
        data = JSON.parse(response.body)
        # squadsエンドポイントは players 配列を返す構造
        data.dig('response', 0, 'players') || []
      else
        []
      end
    end
  end

  def fetch_standings
    # "league_standings_2024" というキーで24時間保存
    Rails.cache.fetch("league_standings_2024", expires_in: 24.hours) do
      response = Faraday.get("#{BASE_URL}/standings") do |req|
        req.headers['x-apisports-key'] = @api_key
        req.params['league'] = '39'
        req.params['season'] = '2024'
      end

      if response.success?
        data = JSON.parse(response.body)
        data.dig('response', 0, 'league', 'standings', 0) || []
      else
        []
      end
    end
  rescue
    []
  end
end