class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    # もし表示しようとしているユーザーが自分自身なら、マイページ(/users/mypage)へ飛ばす
    if @user == current_user
      redirect_to mypage_users_path
      return
    end
    @posts = @user.posts.order(created_at: :desc)
  end
end
