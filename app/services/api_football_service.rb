class ApiFootballService
  def initialize
    # 本来はここにAPIキーを書きますが、今は空にしておきます
    @api_key = "YOUR_API_KEY_HERE"
  end

  def update_team_logos
    # --- 道B：今はファイルからデータを読み込む ---
    file_path = Rails.root.join('db', 'fixtures', 'teams_response.json')
    data = JSON.parse(File.read(file_path))
    
    # --- 本番用（キーが届いたらこちらに切り替えます） ---
    # response = Faraday.get("https://v3.football.api-sports.io/teams?league=39&season=2025") do |req|
    #   req.headers['x-apisports-key'] = @api_key
    # end
    # data = JSON.parse(response.body)

    data["response"].each do |item|
      team_name = item["team"]["name"]
      logo_url = item["team"]["logo"]

      # DBからチームを探して、ロゴURLを更新する
      team = Team.find_by(name: team_name)
      if team
        team.update(logo_url: logo_url)
        puts "Updated: #{team_name}"
      end
    end
  end
end