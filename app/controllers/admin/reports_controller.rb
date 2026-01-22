class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin! # 管理者認証（既存のメソッドを想定）

  def index
    @reports = Report.order(created_at: :desc)
  end

  def show
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to admin_reports_path, notice: "通報ステータスを更新しました。"
    else
      render :show
    end
  end

  private

  def report_params
    params.require(:report).permit(:status)
  end
  
  # adminかどうかを確認するメソッドがない場合は適宜追加（既に実装済みであれば不要）
  def authenticate_admin!
    redirect_to root_path unless current_user&.admin?
  end
end