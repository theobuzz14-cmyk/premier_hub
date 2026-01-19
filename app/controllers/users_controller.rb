class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @posts = @user.posts.order(created_at: :desc) # 自分が投稿したスレッド一覧
  end
end
