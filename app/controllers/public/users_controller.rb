class Public::UsersController < ApplicationController
  before_action :set_user, only: [:mypage, :show, :edit, :update, :withdraw_check, :withdraw]

  def mypage
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました。"
    else
      render :edit
    end
  end

  def withdraw_check
    # 退会確認画面
  end

  def withdraw
    @user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "アカウントを削除しました。"
  end

  private

  # ユーザー情報を取得
  def set_user
    @user = User.find(params[:id])
  end

  # ユーザーパラメータの制御
  def user_params
    params.require(:user).permit(:last_name, :first_name, :nickname, :email, :password, :bio, :is_active)
  end
end