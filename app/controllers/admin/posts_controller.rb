class Admin::PostsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :admin_user           # 管理者必須（先ほど作ったメソッド）

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "不適切な投稿を削除しました。"
  end
end