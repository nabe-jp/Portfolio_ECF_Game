class Public::Users::UserPostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
Rails.logger.info "送信されたparams: #{params[:user_post_comment].inspect}"

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
    
    # コメントを行ったユーザー自身か投稿を作成したユーザーかの判定
    if @comment.user == current_user
      deleted_reason = :self_deleted
    else
      deleted_reason = :post_user
    end
  
    begin
      Deleter::UserPostCommentDeleter.new(@comment, deleted_by: current_user, 
        deleted_reason: deleted_reason).call
      redirect_to user_post_path(@comment.user_post.user, @comment.user_post), notice: 'コメントを削除しました。'
    rescue => e
      Rails.logger.error("UserPostComment削除エラー: #{e.message}")
      redirect_to user_post_path(@comment.user_post.user, @comment.user_post), alert: '削除に失敗しました。'
    end
  end

  private

  def store_form_data(attributes:, error_messages:)
    session[:user_post_comment_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = "コメントの投稿"
  end
  
  def user_post_comment_params
    params.require(:user_post_comment).permit(:body, :parent_comment_id)
  end
end
