class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時にnameカラムを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # プロフィール更新時にnameカラムを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private
  # 退会（アカウント削除）後の遷移先を指定
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :user
      new_user_registration_path # 新規登録画面
    else
      root_path
    end
  end
end
