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
    begin
      Deleter::UserDeleter.call(@user, deleted_by: current_admin)
      redirect_to admin_user_path(@user), notice: 'ユーザーと関連データを削除しました'
    rescue => e
      Rails.logger.error("User削除エラー: #{e.message}")
      redirect_to admin_root_path, alert: '予期せぬエラーにより、ユーザーと関連データの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::UserRestorer.call(@user)
      redirect_to admin_user_path(@user), notice: 'ユーザーと関連データを復元しました'
    rescue => e
      Rails.logger.error("User復元エラー: #{e.message}")
      redirect_to admin_root_path, alert: '予期せぬエラーにより、ユーザーと関連データの復元が行えませんでした。'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end