class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: [:edit, :update, :mypage, :settings, :check, :withdraw]
  before_action :set_user, only: [:show]


  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_mypage_path, notice: "ユーザー情報を更新しました。"
    else
      render :edit
    end
  end

  # ユーザー詳細
  def mypage
  end

  # 設定変更への一覧表示
  def settings
  end

  # 退会確認画面
  def check
  end

  def withdraw
    @user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "アカウントを削除しました。"
  end

  private

  # ユーザー情報を取得
  def set_current_user
    @user = current_user
  end

  def set_user
    @user = User.find(params[:id])
  end
 
  # ユーザーパラメータの制御
  def user_params
    params.require(:user).permit(:last_name, :first_name, :nickname, :email, :password, :bio, :is_active)
  end
end