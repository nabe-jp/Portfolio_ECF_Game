class ApplicationController < ActionController::Base
  # CSRF攻撃を防ぐためのRailsの機能、with: :exceptionはトークンが不正なら例外を投げてリクエストを拒否
  # CSRトークンが切れた状態でログインしようとした際に優しくリダイレクト
  protect_from_forgery with: :exception

  # CSRFトークンエラーのハンドリング
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_auth_token

  private

  def handle_invalid_auth_token
    # ログインしているならログアウトさせる
    sign_out current_user if user_signed_in?

    # フラッシュメッセージを表示
    flash[:alert] = "セッションの有効期限が切れました。もう一度ログインしてください。"

    # Deviseのログイン画面へリダイレクト
    redirect_to root_path
  end
end