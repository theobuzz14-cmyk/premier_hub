class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  # 1. 参加申請一覧（オーナー専用画面用）
  def index
    @group = Group.find(params[:group_id])
    # 設計書：オーナー以外はアクセス不可
    unless @group.owner_id == current_user.id
      redirect_to groups_path, alert: "権限がありません"
    end
    # ステータスが「pending(0)」のユーザーのみを抽出
    @pending_users = @group.group_users.where(status: :pending)
  end

  # 2. 参加申請の作成
  def create
    @group = Group.find(params[:group_id])
    # 現在のユーザーとして中間テーブルのレコードを作成
    @group_user = current_user.group_users.new(group_id: @group.id)
    # statusのデフォルト値はマイグレーションで0(pending)に設定済み
    if @group_user.save
      redirect_to group_path(@group), notice: "[Success] 参加申請を送りました。承認をお待ちください。"
    else
      redirect_to group_path(@group), alert: "申請に失敗しました。"
    end
  end

  # 3. 参加承認（ステータスの更新）
  def update
    @group_user = GroupUser.find(params[:id])
    # ステータスを「approved(1)」に更新
    if @group_user.update(status: :approved)
      redirect_to group_group_users_path(@group_user.group), notice: "[Success] 参加を承認しました。"
    else
      redirect_to group_group_users_path(@group_user.group), alert: "承認に失敗しました。"
    end
  end

  # 4. 退会 または 申請の却下（レコードの削除）
  def destroy
    @group_user = GroupUser.find(params[:id])
    @group = @group_user.group
    @group_user.destroy
    redirect_to groups_path, notice: "[Success] グループを離脱しました（または申請を却下しました）。"
  end
end