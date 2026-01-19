class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def show
    @user = current_user
    @posts = @user.posts.order(created_at: :desc) # 自分が投稿したスレッド一覧
    @commented_posts = Post.joins(:comments).where(comments: { user_id: @user.id }).distinct.order(created_at: :desc)
  end
end
