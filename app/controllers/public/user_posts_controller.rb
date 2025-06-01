class Public::UserPostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show]
  before_action :set_current_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user_post, only: [:show, :edit, :update, :destroy]

  # 投稿一覧
  def index
    # user_idがparamsに含まれている場合、そのユーザーの投稿一覧を表示し、なければ全ユーザーの投稿を表示
    if params[:user_id].present?
      @user = User.where(is_deleted: false).find_by(id: params[:user_id])

      # @userが見つからない場合も想定
      if @user.nil?
        redirect_to root_path, alert: '指定されたユーザーが見つかりませんでした。'
        return
      end
      @user_posts = @user.user_posts.active.page(params[:page])
    else
      @user_posts = UserPost.includes(:user).active.page(params[:page])
    end
  end

  def show
    @user_post_comments = @user_post.user_post_comments.includes(:user).order(created_at: :desc)
    # 入力値がセッションに残っている場合、フォームに表示
    if session[:user_post_comment_attributes]
      @user_post_comment = @user_post.user_post_comments.new(session[:user_post_comment_attributes])
      session[:user_post_comment_attributes] = nil
    else
      @user_post_comment = @user_post.user_post_comments.new
    end
  end

  def new
    @url = user_posts_path(@user)
    @verd = :post
    @user_post = @user.user_posts.new(user_post_attributes_from_session)
  end

  def create
    @user_post = current_user.user_posts.new(user_post_params)
  
    # AI機能(API)実装のため一時的に追加
    tags = Vision.get_image_data(user_post_params[:user_post_image])
    # -------------------------------

    if @user_post.save
      # AI機能(API)実装のため一時的に追加
      # AIタグ付け処理 with リトライ対応
      retries = 0

      begin
        @user_post.tag_list.add(tags)
        @user_post.save!
      rescue SQLite3::BusyException
        retries += 1
        if retries <= 3
          sleep(0.2)  # 少し待ってから再試行（200ミリ秒）
          retry
        else
          flash[:alert] = "データベースが一時的に使用中です。もう一度お試しください。"
          return redirect_to new_user_post_path(@user)
        end
      end
      # -------------------------------

      # 投稿成功 → 最終投稿日時を更新
      @user.update(last_user_posted_at: Time.current)
      session[:user_post_attributes] = nil
      redirect_to user_post_path(@user, @user_post), notice: "投稿が作成されました。"
    else
      store_form_data(attributes: user_post_params, error_messages: 
        @user_post.errors.full_messages, error_name: "投稿")
      redirect_to new_user_post_path(current_user)
    end
  end 

  def edit
    @url = user_post_path(@user.id)
    @verd = :patch
    if session[:user_post_attributes]
      @user_post.assign_attributes(session[:user_post_attributes])
      session.delete(:user_post_attributes)
    end
  end
  
  def update
    if @user_post.update(user_post_params)
      session.delete(:user_post_attributes)
      redirect_to user_post_path(@user, @user_post), notice: '投稿を更新しました。'
    else
      store_form_data(attributes: user_post_params, error_messages: @user_post.errors.full_messages)
      redirect_to edit_user_post_path(@user, @user_post)
    end
  end
  
  def destroy
    begin
      Deleter::UserPostDeleter.call(@user_post, deleted_by: current_user)
      redirect_to user_posts_path(@user), notice: '投稿を削除しました。'
    rescue => e
      Rails.logger.error("UserPost削除エラー: #{e.message}")
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
  def set_user_post
    # user_idが指定されている場合はそのユーザーの投稿を取得
    if @user
      @user_post = @user.user_posts.find_by(id: params[:id])
    end
  end

  def user_post_attributes_from_session
    session[:user_post_attributes] || {}
  end

  # 入力情報とエラーメッセージをセットする
  def store_form_data(attributes:, error_messages:, error_name: nil)
    # error_nameがnilなら"更新"を設定
    error_name ||= "更新"
    session[:user_post_attributes] = attributes.except("user_post_image")
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def user_post_params
    params.require(:user_post).permit(:user_post_image, :title, :body)
  end
end
