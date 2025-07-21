class ApplicationController < ActionController::Base
  # CSRF攻撃を防ぐためのRailsの機能、with: :exceptionはトークンが不正なら例外を投げてリクエストを拒否
  # CSRトークンが切れた状態でログインしようとした際に優しくリダイレクト
  protect_from_forgery with: :exception

  # CSRFトークンエラーのハンドリング
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_auth_token

  private

  def handle_invalid_auth_token
    if admin_signed_in? || request.path.starts_with?('/admin')
      sign_out current_admin if admin_signed_in?
      flash[:alert] = 'セッションの有効期限が切れました為、もう一度ログインしてください'
      redirect_to new_admin_session_path
    else
      sign_out current_user if user_signed_in?
      flash[:alert] = 'セッションの有効期限が切れました為、もう一度ログインしてください'
      redirect_to new_user_session_path
    end
  end
end