class Public::Groups::GroupPostCommentsController < Public::ApplicationController
  include Public::AuthorizeGroup

  # 読み込んだモジュールのメソッドをviewで使用する為に必要
  helper_method :group_post_comment_editor!

  before_action :authenticate_user!
  before_action :set_group_post
  before_action :authorize_group_member!
  before_action :set_current_user, only: [:create]
  before_action :authorize_group_post_comment_editor!, only: [:destroy]

  def create
    @group_post = GroupPost.find(params[:group_post_id]) unless defined?(@group_post)
    @group_post_comment = @group_post.group_post_comments.build(comment_params)
    @group_post_comment.member = @group_membership

    if @group_post_comment.save
      session[:group_post_comment_attributes] = nil
      flash[:notice] = "コメントを投稿しました"
      redirect_to group_post_path(@group, @group_post)
    else
      store_form_data(attributes: comment_params, 
        error_messages: @group_post_comment.errors.full_messages)
      redirect_to group_post_path(@group, @group_post, anchor: 'comment_form')
    end
  end

  def destroy
    @comment = @group_post.group_post_comments.find(params[:id])

    # コメントを行ったユーザー自身かグループ管理者か投稿を作成したユーザーかの判定
    if @comment.member.user == current_user
      deleted_reason = :self_deleted
    elsif group_moderator?
      deleted_reason = :premoved_by_group_authority
    else
      deleted_reason = :post_user
    end

    begin
      Deleter::GroupPostCommentDeleter.new(@comment, deleted_by: current_user, 
        deleted_reason: deleted_reason).call
      redirect_to group_post_path(@group, @group_post),
        notice: "コメントを削除しました"
    rescue => e
      Rails.logger.error("コメント削除エラー: #{e.message}")
      redirect_to group_post_path(@group, @group_post), 
        alert: '予期せぬエラーにより、コメントの削除が行えませんでした。'
    end
  end

  private

  def set_group_post
    @group_post = @group.group_posts.active_group_posts_for_all_desc.find(params[:post_id])
  end

  def set_current_user
    @group_membership = @group.group_memberships.active_members.find_by(user_id: current_user.id)
  end
  
  def store_form_data(attributes:, error_messages:)
    session[:user_post_comment_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = "コメントの投稿"
  end
  
  def comment_params
    params.require(:group_post_comment).permit(:body, :parent_comment_id)
  end
end