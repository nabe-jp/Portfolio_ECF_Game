class Public::PostsController < ApplicationController
  before_action :set_user
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # 編集・削除権限を確認
  before_action :authorize_user, only: [:edit, :update, :destroy]
  
  # 新規投稿作成フォーム
  def new
    @post = current_user.posts.new(flash[:post_attributes] || {})
    @form_url = user_posts_path(current_user)
  end

  # 投稿一覧
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.order(created_at: :desc)
  end

  # 投稿詳細
  def show
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
  end

  # 投稿作成
  def create
    @post = current_user.posts.new(post_params)
  
    if @post.save
      redirect_to user_posts_path(current_user), notice: "投稿が作成されました。"
    else
      flash[:error_messages] = @post.errors.full_messages
      flash[:post_attributes] = post_params
      redirect_to new_user_post_path(current_user)
    end
  end  

  # 投稿編集
  def edit
    @post = @user.posts.find(params[:id])
    @post.assign_attributes(flash[:post_attributes]) if flash[:post_attributes]
  end
  # 投稿更新
  def update
    if @post.update(post_params)
      redirect_to user_post_path(@user, @post), notice: '投稿を更新しました。'
    else
      flash[:error_messages] = @post.errors.full_messages
      flash[:post_attributes] = post_params
      redirect_to edit_user_post_path(@user, @post)
    end
  end
  
  # 投稿削除
  def destroy
    @user = User.find(params[:user_id])
    @post = @user.posts.find(params[:id])
    @post.destroy
    redirect_to user_posts_path(@user), notice: '投稿を削除しました。'
  end

  private

  # ユーザーを取得
  def set_user
    @user = User.find(params[:user_id])
  end

  # 投稿を取得
  def set_post
    @post = @user.posts.find(params[:id])
  end

  # 投稿パラメータの制御
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
