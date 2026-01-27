class Admin::PostsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :admin_user           # 管理者必須

  def index
    @posts = Post.includes(:team, :user).all.order(created_at: :desc)
    @comments = Comment.includes(:user, post: :team).all.order(created_at: :desc)
    @groups = Group.all.order(created_at: :desc)
    
    # ダッシュボード用の統計データ
    @total_posts_count = Post.count
    @total_users_count = User.count
    @today_posts_count = Post.where(created_at: Time.zone.now.all_day).count
    @total_comments_count = Comment.count
    @total_groups_count = Group.count
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "不適切な投稿を削除しました。"
  end
end