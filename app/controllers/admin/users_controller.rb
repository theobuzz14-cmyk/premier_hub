class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

  def index
    @users = User.all.order(created_at: :desc)
  end

  def update
    @user = User.find(params[:id])
    # is_active カラムを反転させる（有効 ↔ 無効）
    if @user.update(is_active: !@user.is_active)
      redirect_to admin_users_path, notice: "ユーザーステータスを更新しました。"
    else
      render :index
    end
  end
end