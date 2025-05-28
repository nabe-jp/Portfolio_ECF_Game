class Public::UserPostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_post = UserPost.find(params[:post_id])
    @user_post_comment =  @user_post.user_post_comments.build(user_post_comment_params)
    @user_post_comment.user = current_user

    if @user_post_comment.save
      session[:user_post_comment_attributes] = nil
      flash[:notice] = "コメントを投稿しました"
      redirect_to user_post_path(@user_post.user, @user_post)
    else
      store_form_data(attributes: user_post_comment_params, 
        error_messages: @user_post_comment.errors.full_messages)
      redirect_to user_post_path(@user_post.user, @user_post, anchor: 'comment_form')
    end
  end

  def destroy
    @user_post = UserPost.find(params[:post_id])
    @comment = @user_post.user_post_comments.find(params[:id])
  
    begin
      Deleter::UserPostCommentDeleter.call(@comment, deleted_by: current_user)
      redirect_to user_post_path(@comment.user_post), notice: 'コメントを削除しました。'
    rescue => e
      Rails.logger.error("コメント削除エラー: #{e.message}")
      redirect_to user_post_path(@comment.user_post), alert: '削除に失敗しました。'
    end
  end

  private

  def store_form_data(attributes:, error_messages:)
    session[:user_post_comment_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = "コメントの投稿"
  end
  
  def user_post_comment_params
    params.require(:user_post_comment).permit(:body)
  end
end
