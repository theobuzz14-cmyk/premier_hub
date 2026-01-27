class Admin::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

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
  
end