class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    @posts = @team.posts.includes(:user) # チームに紐づく投稿一覧 , .includes(:user) を入れると動作が軽くなる 
  end
end
