class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_team

  def new
    @post = @team.posts.build
  end

  def create
    @post = @team.posts.build(post_params)
    @post.user = current_user # ログイン中のユーザーを投稿者に設定
    if @post.save
      redirect_to team_path(@team), notice: "スレッドを投稿しました！"
    else
      render :new
    end
  end

  def show
    @post = @team.posts.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id]) # 自分の投稿のみ編集可能にする
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to team_post_path(@team, @post), notice: "スレッドを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to team_path(@team), notice: "スレッドを削除しました"
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end