class Public::PostsController < ApplicationController
  before_action :set_user
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # 新規投稿作成フォーム
  def new
    @post = @user.posts.new
  end

  # 投稿一覧
  def index
    @posts = @user.posts.all
  end

  # 投稿詳細
  def show
  end

  # 投稿作成
  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to user_posts_path(current_user), notice: "投稿が作成されました。"
    else
      render :new, alert: "投稿に失敗しました。もう一度試してください。"
    end
  end

  # 投稿編集
  def edit
  end

  # 投稿更新
  def update
    if @post.update(post_params)
      redirect_to user_post_path(@user, @post), notice: '投稿が更新されました。'
    else
      render :edit
    end
  end

  # 投稿削除
  def destroy
    @post.destroy
    redirect_to user_posts_path(@user), notice: '投稿が削除されました。'
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
