class Public::UsersController < ApplicationController
  before_action :set_user, only: [:mypage, :show, :edit, :update, :destroy]

  def mypage
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @user.is_active()
    redirect_to root_path, notice: 'アカウントが削除されました。'
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