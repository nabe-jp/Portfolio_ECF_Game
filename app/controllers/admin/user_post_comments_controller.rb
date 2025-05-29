class Admin::UserPostCommentsController < Admin::ApplicationController

  include Admin::FilteredRecords

  def index
    @show_non_public = ActiveModel::Type::Boolean.new.cast(params[:show_non_public])
    @show_deleted = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    @show_all = params[:show] == "all"

    @user_post_comments = filtered_records(UserPostComment).order(*sort_order).page(params[:page]).per(10)
  end

  def show
    @user_post_comment = UserPostComment.find(params[:id])
  end

  # 削除時、非公開にもする
  def destroy
    @user_post_comment = UserPostComment.find(params[:id])
  
    begin
      Deleter::UserPostCommentDeleter.call(@comment, deleted_by: current_admin)
      redirect_to admin_user_post_comment_path(@user_post_comment), notice: "コメントを削除しました"
    rescue => e
      Rails.logger.error("UserPostCmment削除エラー: #{e.message}")
      redirect_to admin_root_path, alert: '予期せぬエラーにより、ユーザーと関連データの削除が行えませんでした。'
    end
  end

  def reactivate
    @user_post_comment = UserPostComment.find(params[:id])
    @user_post_comment.update(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    redirect_to admin_user_post_comment_path(@user_post_comment), notice: "コメントを復元しました"
  end

  def hide
    @user_post_comment = UserPostComment.find(params[:id])
    @user_post_comment.update(is_public: false)
    redirect_to admin_user_post_comment_path(@user_post_comment), notice: "コメントを非公開にしました"
  end

  def publish
    @user_post_comment = UserPostComment.find(params[:id])
    @user_post_comment.update(is_public: true)
    redirect_to admin_user_post_comment_path(@user_post_comment), notice: "コメントを公開にしました"
  end
end