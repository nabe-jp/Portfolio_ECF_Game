class Public::Users::UserPostCommentsController < Public::ApplicationController
  before_action :authenticate_user!

  before_action :set_user_post
  before_action :set_comment, only: [:destroy] 

  def create
    @user_post_comment =  @user_post.user_post_comments.build(user_post_comment_params)
    @user_post_comment.user = current_user

    if @user_post_comment.save
      session[:user_post_comment_attributes] = nil
      flash[:notice] = 'コメントを投稿しました'
      redirect_to user_post_path(@user_post.user, @user_post)
    else
      Form::DataStorageService.store(session: session, flash: flash, 
        attributes: user_post_comment_params, error_messages: @user_post_comment.errors.full_messages, 
          error_name: 'コメントの投稿', key: :user_post_comment_attributes)
      redirect_to user_post_path(@user_post.user, @user_post, anchor: 'comment_form')
    end
  end

  def destroy
    # 削除権限の確認
    unless @comment.user == current_user || @comment.user_post.user == current_user
      redirect_to user_post_path(@comment.user_post.user, @comment.user_post), 
        alert: 'コメントの削除権限がありません' and return
    end

    # コメントを行ったユーザー自身か投稿を作成したユーザーかの判定
    if @comment.user == current_user
      deleted_reason = :self_deleted
    else
      deleted_reason = :post_user
    end
  
    begin
      Deleter::UserPostCommentDeleter.new(@comment, deleted_by: current_user, 
        deleted_reason: deleted_reason).call
      redirect_to user_post_path(@comment.user_post.user, @comment.user_post), 
        notice: 'コメントを削除しました'
    rescue => e
      Rails.logger.error("UserPostComment削除エラー: #{e.message}")
      redirect_to user_post_path(@comment.user_post.user, @comment.user_post), 
        alert: '予期せぬエラーにより、コメントの削除が行えませんでした'
    end
  end

  private
  
  def set_user_post
    @user_post = UserPost.active_post.find(params[:post_id])
  end

  def set_comment
    @comment = @user_post.user_post_comments.active_post_comment.find(params[:id])
  end

  def user_post_comment_params
    params.require(:user_post_comment).permit(:body, :parent_comment_id)
  end
end
