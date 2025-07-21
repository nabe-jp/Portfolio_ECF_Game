class Admin::Groups::GroupPostCommentsController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_group
  before_action :set_group_post_comment, only: [:show, :destroy, :reactivate]
  
  def index
    # グループに紐づくコメントのみを対象にフィルターを適用する
    @group_post_comments = filtered_records(
      GroupPostComment.joins(:group_post).where(group_posts: { group_id: @group.id })
    ).order(*sort_order).page(params[:page])
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しコメントの論理削除を行う
      Deleter::GroupPostCommentDeleter.new(@group_post_comment, deleted_by: current_admin, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_post_comment_path(@group.id, @group_post_comment), 
        notice: 'コメントを削除しました'
    rescue => e
      Rails.logger.error("GroupPostComment削除エラー: #{e.message}")
      redirect_to admin_group_post_comment_pathh(@group.id, @group_post_comment), 
        alert: '予期せぬエラーにより、コメントの削除が行えませんでした'
    end
  end

  def reactivate
    begin
      Restorer::GroupPostCommentRestorer.new(@group_post_comment).call
      redirect_to admin_group_post_comment_path(@group.id, @group_post_comment), 
        notice: 'コメントを復元しました'
    rescue => e
      Rails.logger.error("GroupPostComment復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした'
      redirect_to admin_group_post_comment_path(@group.id, @group_post_comment)
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupPostComment.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_post_comment
    @group_post_comment = GroupPostComment.joins(:group_post)
    .where(group_posts: { group_id: @group.id })
    .find(params[:id])
  end
end