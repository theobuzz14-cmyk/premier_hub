class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      redirect_back fallback_location: root_path, notice: "通報を送信しました。ご協力ありがとうございます。"
    else
      redirect_back fallback_location: root_path, alert: "通報の送信に失敗しました。理由を入力してください。"
    end
  end

  private

  def report_params
    # thread_id (スレッド用), comment_id (コメント用), reason を許可
    params.require(:report).permit(:thread_id, :comment_id, :reason)
  end
end