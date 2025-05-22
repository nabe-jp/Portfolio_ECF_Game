class Admin::UserPostsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_user_post, only: [:show, :destroy]

  def index
    # 論理削除された投稿も含める
    @user_posts = UserPost.with_deleted.includes(:user)
  end

  def show
  end

  def destroy
    @user_post.update(is_deleted: true)
    redirect_to admin_user_posts_path, notice: "投稿を削除しました"
  end

  private

  def set_user_post
    @user_post = UserPost.with_deleted.find(params[:id])
  end
end