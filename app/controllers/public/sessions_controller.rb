class Public::SessionsController < Devise::SessionsController
  # Deviseの登録機能をオーバーライドしたいときに使用

  before_action :pre_login_active_check, only: [:create]

  protected

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    root_path
  end

  # ログインアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    root_path
  end

  # ログイン前に退会済みか確認を行うためのメソッド
  def pre_login_active_check
    user = User.find_by(email: params[:user][:email])   # find_byは見つからなくてもnilになるだけ
  
    # ユーザーが存在し、パスワードがあっており、退会になっている場合、ログイン出来ないようにする
    if user && user.valid_password?(params[:user][:password]) && !user.is_active
      flash[:alert] = "退会済みアカウントの為、使用できません"
      redirect_to new_user_session_path and return          # returnを使い処理を確実に終え、安定性を高める
    end
  end
end