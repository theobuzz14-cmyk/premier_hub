# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# db/seeds.rb

# db/seeds.rb

# 1. サービスのインスタンス化
service = ApiFootballService.new

# 2. APIからデータを取得してDBに保存（新規作成も行う）
puts "🔄 APIからチーム情報を取得し、DBを構築中..."

# Faradayを使って直接APIを叩き、Teamレコードを生成します
response = Faraday.get("https://v3.football.api-sports.io/teams") do |req|
  req.headers['x-apisports-key'] = Rails.application.credentials.rapidapi[:key]
  req.params['league'] = '39'
  req.params['season'] = '2024' # または最新シーズン
end

data = JSON.parse(response.body)

if data["response"].any?
  data["response"].each do |item|
    api_name = item["team"]["name"]
    logo_url = item["team"]["logo"]
    api_id = item["team"]["id"]

    # ★ ここがポイント：なければ作り、あれば更新する
    team = Team.find_or_initialize_by(name: api_name)
    team.update!(
      logo_url: logo_url,
      api_team_id: api_id
    )
    puts "✅ Saved: #{team.name}"
  end
else
  puts "❌ APIからのデータ取得に失敗しました。"
end

# 3. ユーザーと投稿の作成
user = User.find_or_create_by!(email: "demo-user@example.com") do |u|
  u.name = "プレミア大好き"
  u.password = "Pass1234"
end

# 4. 投稿の作成
target_team = Team.find_by(name: "Arsenal") || Team.first
if target_team
  Post.find_or_create_by!(title: "【デモ】今シーズンの優勝予想！") do |post|
    post.body = "皆さんはどこが優勝すると思いますか？私はアーセナルの分厚い層に期待しています。"
    post.user = user
    post.team = target_team
  end
  puts "✅ デモ用投稿の作成が完了しました！"
end

# --- 管理者ユーザーの作成 ---
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "管理者"
  u.password = "AdminPass123"
  u.admin = true # 管理者フラグを立てる
end
puts "✅ 管理者ユーザーを作成しました！"

# --- デモ投稿へのコメント追加 ---
demo_post = Post.find_by(title: "【デモ】今シーズンの優勝予想！")
if demo_post
  Comment.find_or_create_by!(body: "私はマンチェスター・シティが4連覇すると思います！") do |c|
    c.user = admin
    c.post = demo_post
  end
  
  Comment.find_or_create_by!(body: "アーセナルの守備陣ならシティを止められるはず...") do |c|
    c.user = User.find_by(email: "demo-user@example.com")
    c.post = demo_post
  end
  puts "✅ デモコメントを追加しました！"
end