class Admin::UsersController < Admin::ApplicationController

  before_action :set_user, only: [:show, :update, :deactivate, :reactivate]

  def index
    # 初期アクセス時に status パラメータがなければ、有効ユーザーにリダイレクト
    unless params.key?(:status)
      redirect_to admin_users_path(status: "active", direction: params[:direction]) and return
    end

    # デフォルト: 有効ユーザー
    @users = User.where(is_deleted: false)
  
    case params[:status]
    when "inactive"
      @users = User.where(is_deleted: true)
    when "all"
      @users = User.all
    end
  
    # 並び替え
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
    @users = @users.order(id: direction)
  
    @users = @users.page(params[:page]).per(10)
  end
  

  def show
    @user_posts = @user.user_posts.order(created_at: :desc)
  end

  def update
    # 未使用
  end

  def deactivate
    @user.update(is_deleted: true)
    redirect_to admin_user_path(@user), notice: 'ユーザーを凍結または退会状態にしました。'
  end

  def reactivate
    @user.update(is_deleted: false)
    redirect_to admin_user_path(@user), notice: 'ユーザーを復元しました。'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end