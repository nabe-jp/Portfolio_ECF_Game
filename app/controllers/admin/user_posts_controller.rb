class Admin::UserPostsController < Admin::ApplicationController

  before_action :set_user_post, only: [:show, :destroy, :reactivate, :hide, :publish]

  def index
    # パラメータを論理値に変換して状態を保持
    @show_non_public = ActiveModel::Type::Boolean.new.cast(params[:show_non_public])
    @show_deleted     = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    @show_all         = params[:show] == "all"
  
    # 絞り込み済みの投稿に並び順を適用し、ページネーション
    @user_posts = filtered_posts.order(*sort_order).page(params[:page]).per(10)
  end

  def show
  end
  
  # 削除時、非公開にもする
  def destroy
    @user_post.update(is_deleted: true, is_public: false, deleted_at: Time.current,
      deleted_by_id: current_admin.id)
    redirect_to admin_user_post_path(@user_post), notice: "投稿を削除しました"
  end
  
  def reactivate
    @user_post.update(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    redirect_to admin_user_post_path(@user_post), notice: "投稿を復元しました"
  end
  
  def hide
    @user_post.update(is_public: false)
    redirect_to admin_user_post_path(@user_post), notice: "投稿を非公開にしました"
  end
  
  def publish
    @user_post.update(is_public: true)
    redirect_to admin_user_post_path(@user_post), notice: "投稿を公開にしました"
  end

  private

  # 投稿一覧の絞り込みロジック
  def filtered_posts
  base = UserPost.includes(:user)                             # N+1回避のためにユーザー情報を事前読み込み

  # 各表示状態に対応するスコープを定義(独立していて互いに影響を与えない)
  public_scope     = UserPost.where(is_public: true, is_deleted: false)
  non_public_scope = UserPost.where(is_public: false, is_deleted: false)
  deleted_scope    = UserPost.where(is_deleted: true)

  # 表示状態の組み合わせに応じてスコープを適用
  if @show_all
    base  # すべての投稿を表示
  elsif @show_non_public && @show_deleted
    base.merge(non_public_scope.or(deleted_scope))            # 非公開と削除済みを両方表示
  elsif @show_non_public
    base.merge(non_public_scope)                              # 非公開のみ表示
  elsif @show_deleted
    base.merge(deleted_scope)                                 # 削除済みのみ表示
  else
    base.merge(public_scope)                                  # 初期状態：公開中のみ表示
  end
end

# 並び順の判定と返却(created_at, id の複合キー)
def sort_order
  direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
  [{ created_at: direction }, { id: direction }]              # 作成日時 → ID の順で並べる
end

  def set_user_post
    @user_post = UserPost.find(params[:id])
  end
end