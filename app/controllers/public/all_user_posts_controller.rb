class Public::AllUserPostsController < ApplicationController
  def index
    @user_posts = UserPost.includes(:user).active.page(params[:page])
  end
end
