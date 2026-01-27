class Admin::GroupsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :admin_user         # 管理者必須


  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_posts_path, notice: "グループ「#{@group.name}」を強制削除しました。", status: :see_other
  end

end