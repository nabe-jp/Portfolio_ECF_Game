class Public::RegistrationsController < Devise::RegistrationsController
  # Deviseの登録機能をオーバーライドしたいときに使用
  # ユーザーのサインアップ処理の前に特定のパラメータを許可する
  before_action :configure_sign_up_params, only: [:create]
  # ログインに必要なユーザー情報の更新に使用
  before_action :configure_account_update_params, only: [:update]

  protected

  # 新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    mypage_path
  end

  # アカウント更新後のリダイレクト先（任意で追加）
  def after_update_path_for(resource)
    mypage_path
  end

  # サインアップ時に許可するパラメータ
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :nickname])
  end

  # アカウント更新時に許可するパラメータ
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:last_name, :first_name, :nickname])
  end
end
