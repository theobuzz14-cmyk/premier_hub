class ApplicationController < ActionController::Base
  before_action :check_user_status
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected
  def configure_permitted_parameters
    # 新規登録時にnameカラムを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # プロフィール更新時にnameカラムを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private
  def check_user_status
    if user_signed_in? && !current_user.is_active
      sign_out current_user
      redirect_to root_path, alert: "このアカウントは現在ご利用いただけません。"
    end
  end

  # 退会（アカウント削除）後の遷移先を指定
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :user
      new_user_registration_path # 新規登録画面
    else
      root_path
    end
  end

  # 管理者かどうかをチェックし、そうでなければトップへ強制送還する
  def admin_user
    unless current_user&.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end
end
