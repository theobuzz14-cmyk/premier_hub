class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      # 作成したオーナーも最初のメンバー（承認済）として登録する
      @group.group_users.create(user_id: current_user.id, status: :approved)
      redirect_to group_path(@group), notice: "[Success] グループを作成しました"
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "[Update] グループ情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path, notice: "[Delete] グループを削除しました"
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :team_id)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path, alert: "オーナーのみ編集・削除が可能です"
    end
  end
end