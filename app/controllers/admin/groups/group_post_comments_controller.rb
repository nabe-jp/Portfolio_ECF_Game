class Admin::Groups::GroupPostCommentsController < Admin::ApplicationController
  include Admin::Publishable

  before_action :set_group
  before_action :set_group_post_comment, only: [:show, :destroy, :reactivate]
  
  def index
    @group_post_comments = GroupPostComment.where(group_post_id: @group.group_posts.select(:id))
    .where(is_deleted: false)
    .includes(:member, :group_post)
    .order(created_at: :desc)
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しコメントの論理削除を行う
      Deleter::GroupPostCommentDeleter.new(@group_post_comment, deleted_by: current_user, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_comments_path(@group), 
        notice: 'コメントを削除しました。'
    rescue => e
      Rails.logger.error("GroupPostComment削除エラー: #{e.message}")
      redirect_to admin_group_comments_path(@group), 
        alert: '予期せぬエラーにより、コメントの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupPostCommentRestorer.new(@group, @group_post_comment).call
      redirect_to admin_group_comment_path(@group, @group_post_comment), 
        notice: 'コメントを復元しました'
    rescue => e
      Rails.logger.error("GroupPostComment復元エラー: #{e.message}")
      redirect_to admin_group_comment_path(@group, @group_post_comment), 
        alert: '予期せぬエラーにより、コメントの復元が行えませんでした。'
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