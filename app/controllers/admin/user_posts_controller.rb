class Admin::UserPostsController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_user_post, only: [:show, :destroy, :reactivate]

  def index
    # 絞り込み済みの投稿に並び順を適用し、ページネーション
    @user_posts = filtered_records(UserPost).order(*sort_order).page(params[:page])
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
        alert: '予期せぬエラーにより、投稿と関連データの削除が行えませんでした'
    end
  end
  
  def reactivate
    begin
      Restorer::UserPostRestorer.new(@user_post).call
      redirect_to admin_user_post_path(@user_post), notice: '投稿と関連データを復元しました'
    rescue => e
      Rails.logger.error("UserPost復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした'
      redirect_to admin_user_post_path(@user_post)
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = UserPost.find(params[:id])
  end

  private

  def set_user_post
    @user_post = UserPost.find(params[:id])
  end
end