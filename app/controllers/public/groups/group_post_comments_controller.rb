class Public::Groups::GroupPostCommentsController < Public::ApplicationController
  include Public::AuthorizeGroup

  before_action :authenticate_user!
  before_action :set_group_post
  before_action :authorize_group_member!
  before_action :set_group_membership, only: [:create]
  before_action :set_comment, only: [:destroy] 
  before_action :authorize_group_post_comment_editor!, only: [:destroy]

  def create
    @group_post_comment = @group_post.group_post_comments.build(group_post_comment_params)
    @group_post_comment.member = @group_membership

    if @group_post_comment.save
      flash[:notice] = "コメントを投稿しました"
      redirect_to group_post_path(@group, @group_post)
    else
      Form::DataStorageService.store(session: session, flash: flash, 
        attributes: group_post_comment_params, 
          error_messages: @group_post_comment.errors.full_messages, 
            error_name: 'コメントの投稿', key: :group_post_comment_attributes)
      redirect_to group_post_path(@group, @group_post, anchor: 'comment_form')
    end
  end

  def destroy
    # コメントを行ったユーザー自身かグループ管理者か投稿を作成したユーザーかの判定
    if @comment.member.user == current_user
      deleted_reason = :self_deleted
    elsif group_moderator?
      deleted_reason = :removed_by_group_authority
    else
      deleted_reason = :post_user
    end

    begin
      Deleter::GroupPostCommentDeleter.new(@comment, deleted_by: current_user, 
        deleted_reason: deleted_reason).call
      redirect_to group_post_path(@group, @group_post),
        notice: "コメントを削除しました"
    rescue => e
      Rails.logger.error("GroupPostComment削除エラー: #{e.message}")
      redirect_to group_post_path(@group, @group_post), 
        alert: '予期せぬエラーにより、コメントの削除が行えませんでした。'
    end
  end

  private

  def set_group_post
    @group_post = @group.group_posts.active_group_post_for_members.find(params[:post_id])
  end

  def set_group_membership
    @group_membership = @group.group_memberships.active_members.find_by(user_id: current_user.id)
  end

  def set_comment
    @comment = @group_post.group_post_comments.active_group_post_comment.find(params[:id])
  end
  
  def group_post_comment_params
    params.require(:group_post_comment).permit(:body, :parent_comment_id)
  end
end