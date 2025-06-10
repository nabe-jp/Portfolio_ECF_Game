class Public::AllUserPostsController < ApplicationController
  
  def index
    @user_posts = UserPost.includes(:user).active_posts_desc.page(params[:page])
  end
end
