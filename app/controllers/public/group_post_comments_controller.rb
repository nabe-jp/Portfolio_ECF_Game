class Public::GroupPostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_group_post

  def create
    @comment = @group_post.group_post_comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to group_post_path(@group, @group_post), notice: 'コメントを投稿しました。'
    else
      flash.now[:alert] = 'コメントを投稿できませんでした。'
      render 'public/group_posts/show'
    end
  end

  def destroy
    @comment = @group_post.group_post_comments.find(params[:id])

    # 権限チェック
    unless @comment.user == current_user || @group.owner_id == current_user.id || current_user.admin?
      redirect_back(fallback_location: root_path, alert: "削除権限がありません") and return
    end

    begin
      Deleter::GroupPostCommentDeleter.call(@comment, deleted_by: current_user)
      redirect_to group_group_post_path(@comment.group_post.group, @comment.group_post),
      notice: "コメントを削除しました"
    rescue => e
      redirect_to root_path, alert: '予期せぬエラーにより、コメントの削除が行えませんでした。'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_post
    @group_post = @group.group_posts.find(params[:group_post_id])
  end

  def comment_params
    params.require(:group_post_comment).permit(:body)
  end
end