class Public::PostsController < ApplicationController
  before_action :set_user, except: [:index]
  before_action :current_user, only: [:new, :create, :edit, :updated, :estroy]
  before_action :set_post, only: [:show, :edit]

  # 投稿一覧
  def index
    # user_idがparamsに含まれている場合、そのユーザーを取得、なければすべての投稿を表示
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])

      # @userがnilの場合、リダイレクト、または自分の投稿一覧か 他のユーザーの投稿一覧かを判別
      if @user.nil?
        redirect_to posts_path, alert: '指定されたユーザーが見つかりませんでした。'
        return
      elsif @user == current_user
        @posts = current_user.posts
      else
        @posts = @user.posts
      end
    else
      @posts = Post.all
    end
  end

  def show

  end

  def new
    @url = user_posts_path
    @verd = :post
    @post = current_user.posts.new(session[:post_attributes] || {})
  end

  def create
    @post = current_user.posts.new(post_params)
  
    if @post.save
      redirect_to post_show_user_path(@post), notice: "投稿が作成されました。"
    else
      store_form_data(attributes: post_params, error_messages: 
        @post.errors.full_messages, error_name: "投稿")
      redirect_to new_user_post_path(current_user)
    end
  end 

  def edit
    @url = user_post_path(@post.id)
    @verd = :patch
    if session[:post_attributes]
      @post.assign_attributes(session[:post_attributes]) if session[:post_attributes]
      session.delete(:post_attributes)
    end
  end
  
  def update
    # タイミングが早すぎるのかset_postを使用するとnilになるので直接記載し@userの参照を遅らせる
    @post = @user.posts.find_by(id: params[:id])
    if @post.update(post_params)
      session.delete(:post_attributes)
      redirect_to post_show_user_path(@post), notice: '投稿を更新しました。'
    else
      store_form_data(attributes: post_params, error_messages: @post.errors.full_messages)
      redirect_to edit_user_post_path(@post)
    end
  end
  
  def destroy
    @post.destroy
    redirect_to post_index_user_path, notice: '投稿を削除しました。'
  end

  private

  # ユーザーを取得
  def set_user
    # user_idがparamsに含まれている場合、そのユーザーを取得,なければカレントユーザーをセット
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])
    elsif current_user
      @user = current_user
    else
      # ログインしていなければ、ログインページにリダイレクト
      redirect_to login_path, alert: 'ログインが必要です。'
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
    else
      # ログインしていなければ、ログインページにリダイレクト
      redirect_to login_path, alert: 'ログインが必要です。'
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
