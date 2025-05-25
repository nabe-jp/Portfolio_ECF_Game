class Admin::UserPostCommentsController < Admin::ApplicationController

  def index
    # パラメータを論理値に変換して状態を保持
    @show_non_public = ActiveModel::Type::Boolean.new.cast(params[:show_non_public])
    @show_deleted     = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    @show_all         = params[:show] == "all"
  
    # フィルター処理
    @user_post_comments = if @show_all
      UserPostComment.all
    else
      scope = UserPostComment.where(is_deleted: false)
      scope = scope.where(is_public: true) unless @show_non_public
      scope
    end
  
    # 並び順（デフォルトは新しい順）
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
    @user_post_comments = @user_post_comments
      .includes(:user, :user_post)
      .order(created_at: direction)
      .page(params[:page]).per(10)
  end
  
  def show
    @user_post_comment = UserPostComment.find(params[:id])
  end
end
