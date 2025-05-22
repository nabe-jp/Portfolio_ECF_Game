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
  
    if  @comment.user == current_user || @user_post.user == current_user
      @comment.update(is_deleted: true)
      flash[:notice] = "コメントを削除しました"
    else
      flash[:alert] = "削除権限がありません"
    end
  
    redirect_to  user_post_path(@user_post.user, @user_post)
  end

  private

  def user_post_comment_params
    params.require(:user_post_comment).permit(:body)
  end

  def store_form_data(attributes:, error_messages:)
    session[:user_post_comment_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = "コメントの投稿"
  end
end
