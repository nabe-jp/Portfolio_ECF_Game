class Admin::UserPostCommentsController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_user_post_comment, only: [:show, :destroy, :reactivate]

  def index
    @user_post_comments = filtered_records(UserPostComment).order(*sort_order).page(params[:page])
  end

  def show; end

  # 削除時、非公開にもする
  def destroy
    begin
      Deleter::UserPostCommentDeleter.new(@user_post_comment, 
        deleted_by: current_admin, deleted_reason: :removed_by_admin).call
      redirect_to admin_user_post_comment_path(@user_post_comment), notice: 'コメントを削除しました'
    rescue => e
      Rails.logger.error("UserPostCmment削除エラー: #{e.message}")
      redirect_to admin_user_post_comment_path(@user_post_comment), 
        alert: '予期せぬエラーにより、コメントの削除が行えませんでした'
    end
  end

  def reactivate
    begin
      Restorer::UserPostCommentRestorer.new(@user_post_comment).call
      redirect_to admin_user_post_comment_path(@user_post_comment), notice: 'コメントを復元しました'
    rescue => e
      Rails.logger.error("UserPostComment復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした'
      redirect_to admin_user_post_comment_path(@user_post_comment)
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = UserPostComment.find(params[:id])
  end

  private

  def set_user_post_comment
    @user_post_comment = UserPostComment.find(params[:id])
  end
end