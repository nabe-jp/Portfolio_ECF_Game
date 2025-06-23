class Public::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_user_posts, only: [:show]
  before_action :set_groups, only: [:show]
  
  def show; end

  private

  # ユーザー情報を取得
  def set_user
    @user = User.active_users.find(params[:id])
  end

  def set_user_posts
    @user_posts = @user.user_posts.active_posts_desc.page(params[:page])
  end

  def set_groups
    @groups = @user.active_joined_groups
      .merge(Group.active_groups_desc).page(params[:joined_page]).per(5)
  end
end