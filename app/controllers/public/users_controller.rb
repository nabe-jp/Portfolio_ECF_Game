class Public::UsersController < ApplicationController

  before_action :set_user, only: [:show]
  
  def show; end

  private

  # ユーザー情報を取得
  def set_user
    @user = User.active_users.find(params[:id])
  end
end