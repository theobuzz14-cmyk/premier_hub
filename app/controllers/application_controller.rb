class ApplicationController < ActionController::Base
  before_action :check_user_status
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_standings


  protected
  def configure_permitted_parameters
    # 新規登録時にnameカラムを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # プロフィール更新時にnameカラムを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:avatar])
  end

  private
  def check_user_status
    if user_signed_in? && !current_user.is_active
      sign_out current_user
      redirect_to root_path, alert: "このアカウントは現在ご利用いただけません。"
    end
  end

  # 退会（アカウント削除）後の遷移先
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # 管理者かどうかをチェックし、そうでなければトップへ強制送還する
  def admin_user
    unless current_user&.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end

  def set_standings
    # 頻繁にAPIを叩くと制限に達するので、一旦簡易的なキャッシュを持たせる
    @standings = Rails.cache.fetch("league_standings_2024", expires_in: 12.hours) do
      ApiFootballService.new.fetch_standings
    end
  end
end
