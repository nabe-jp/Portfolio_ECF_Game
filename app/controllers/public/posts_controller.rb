class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show]
  before_action :set_current_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # 投稿一覧
  def index
    # user_idがparamsに含まれている場合、そのユーザーの投稿一覧を表示し、なければ全ユーザーの投稿を表示
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])

      # @userが見つからない場合も想定
      if @user.nil?
        redirect_to root_path, alert: '指定されたユーザーが見つかりませんでした。'
        return
      end
      @posts = @user.posts.order(created_at: :desc)
    else
      @posts = Post.includes(:user).order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @url = user_posts_path(@user)
    @verd = :post
    @post = @user.posts.new(session[:post_attributes] || {})
  end

  def create
    @post = current_user.posts.new(post_params)
  
    if @post.save
      redirect_to user_post_path(@user, @post), notice: "投稿が作成されました。"
    else
      store_form_data(attributes: post_params, error_messages: 
        @post.errors.full_messages, error_name: "投稿")
      redirect_to new_user_post_path(current_user)
    end
  end 

  def edit
    @url = user_post_path(@user.id)
    @verd = :patch
    if session[:post_attributes]
      @post.assign_attributes(session[:post_attributes]) if session[:post_attributes]
      session.delete(:post_attributes)
    else
      @post = @post
    end
  end
  
  def update
    if @post.update(post_params)
      session.delete(:post_attributes)
      redirect_to user_post_path(@user, @post), notice: '投稿を更新しました。'
    else
      store_form_data(attributes: post_params, error_messages: @post.errors.full_messages)
      redirect_to edit_user_post_path(@user, @post)
    end
  end
  
  def destroy
    if @post.destroy
      redirect_to user_posts_path(@user), notice: '投稿を削除しました。'
    else
      redirect_to root_path, alert: '予期せぬエラーにより、投稿の削除が行えませんでした。'
    end
  end

  private

  # ユーザーを取得
  def set_user
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])

      # ユーザーが見つからない場合はTOPページに行く
      unless @user
        redirect_to root_path, alert: '指定されたユーザーが見つかりませんでした。'
        return
      end
    end
  end

  def set_current_user
    @user = current_user
  end

  # 投稿を取得
  def set_post
    # user_idが指定されている場合はそのユーザーの投稿を取得
    if @user
      @post = @user.posts.find_by(id: params[:id])
    end
  end

  # 入力情報とエラーメッセージをセットする
  def store_form_data(attributes:, error_messages:, error_name: nil)
    # error_nameがnilなら"更新"を設定
    error_name ||= "更新"
    session[:post_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def post_params
    params.require(:post).permit(:post_image, :title, :body)
  end
end
