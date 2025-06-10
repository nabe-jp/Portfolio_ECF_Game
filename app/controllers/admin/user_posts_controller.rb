class Admin::UserPostsController < Admin::ApplicationController
  before_action :set_user_post, only: [:show, :destroy, :reactivate, :hide, :publish]

  def index
    # パラメータを論理値に変換して状態を保持
    @show_non_public = ActiveModel::Type::Boolean.new.cast(params[:show_non_public])
    @show_deleted = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    @show_all = params[:show] == "all"
  
    # 絞り込み済みの投稿に並び順を適用し、ページネーション
    @user_posts = filtered_records(UserPost).order(*sort_order).page(params[:page]).per(10)
  end

  def show
  end
  
  # 削除時、非公開にもする
  def destroy
    begin
      Deleter::UserPostDeleter.new(@user_post, 
        deleted_by: current_admin, deleted_reason: :removed_by_admin).call
      redirect_to admin_user_post_path(@user_post), notice: "投稿を削除しました"
    rescue => e
      Rails.logger.error("UserPost削除エラー: #{e.message}")
      redirect_to admin_user_post_path(@user_post), 
        alert: '予期せぬエラーにより、投稿と関連データの削除が行えませんでした。'
    end
  end
  
  def reactivate
    begin
      Restorer::UserPostRestorer.new(@user_post).call
      redirect_to admin_user_post_path(@user_post), notice: '投稿と関連データを復元しました'
    rescue => e
      Rails.logger.error("UserPost復元エラー: #{e.message}")
      redirect_to admin_user_post_path(@user_post), 
        alert: '予期せぬエラーにより、投稿と関連データの復元が行えませんでした。'
    end
  end
  
  def hide
    @user_post.update(is_public: false)
    redirect_to admin_user_post_path(@user_post), notice: "投稿を非公開にしました"
  end
  
  def publish
    @user_post.update(is_public: true)
    redirect_to admin_user_post_path(@user_post), notice: "投稿を公開にしました"
  end

  private

  def set_user_post
    @user_post = UserPost.find(params[:id])
  end
end