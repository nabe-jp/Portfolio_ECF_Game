class Admin::SessionsController < Devise::SessionsController
  # Deviseの登録機能をオーバーライドしたいときに使用
  # 管理者としてログインしていなければ、ログインページへリダイレクト
  layout 'admin'

  protected

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    admin_root_path
  end

  # ログインアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_admin_session_path
  end
end
