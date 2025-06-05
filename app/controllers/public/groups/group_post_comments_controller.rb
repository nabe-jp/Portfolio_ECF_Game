class Public::Groups::GroupPostCommentsController < ApplicationController
  include ::Public::Concerns::AuthorizeGroup

  before_action :authenticate_user!
  before_action :set_group_post
  before_action :authorize_group_member!
  before_action :set_current_user, only: [:create]

  def create
    @group_post_comment =  @group_post.group_post_comments.build(comment_params)
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

    authorize_comment_deletion!(@comment)

    begin
      Deleter::GroupPostCommentDeleter.call(@comment, deleted_by: current_user)
      redirect_to group_post_path(@group, @group_post),
      notice: "コメントを削除しました"
    rescue => e
      Rails.logger.error("コメント削除エラー: #{e.message}")
      redirect_to root_path, alert: '予期せぬエラーにより、コメントの削除が行えませんでした。'
    end
  end

  private

  def set_group_post
    @group_post = @group.group_posts.find(params[:post_id])
  end

  def set_current_user
    @group_membership = @group.group_memberships.find_by(user_id: current_user.id)
  end

  def authorize_comment_deletion!(comment)
    unless comment.member.user == current_user || comment.group_post.member.user == current_user || 
      comment.group_post.group.owner_id == current_user.id
      redirect_back(fallback_location: root_path, alert: "削除権限がありません") and return
    end
  end
  
  def store_form_data(attributes:, error_messages:)
    session[:user_post_comment_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = "コメントの投稿"
  end
  
  def comment_params
    params.require(:group_post_comment).permit(:body)
  end
end