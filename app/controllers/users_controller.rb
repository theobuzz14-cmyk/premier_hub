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

  def withdraw
    # collection で定義しているので、操作対象は常に本人
    @user = current_user
    
    # 管理者の場合（管理者が誤って自信を削除しないように念のため）
    if @user.admin?
      redirect_to mypage_users_path, alert: "管理者はマイページから退会できません。"
      return
    end

    # 論理削除（ステータス更新）
    if @user.update(is_active: false)
      reset_session # ログインセッションをクリア（ログアウト状態にする）
      redirect_to root_path, notice: "退会処理が完了しました。ご利用ありがとうございました。"
    else
      redirect_to mypage_users_path, alert: "退会処理に失敗しました。"
    end
  end
end