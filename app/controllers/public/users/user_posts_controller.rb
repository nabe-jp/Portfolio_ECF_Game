class Public::Users::UserPostsController < Public::ApplicationController
  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Public::PlaceholdersHelper

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_user_post, only: [:show, :edit, :update, :destroy]

  # 投稿一覧
  def index
      @user_posts = @user.user_posts.active_posts_desc.page(params[:page])
  end

  def show
    @parent_comments = @user_post.user_post_comments
      .visible_top_level.includes(:user, replies: :user).page(params[:page]).per(20)

    # 入力値がセッションに残っている場合、フォームに表示
    if session[:user_post_comment_attributes]
      @user_post_comment = @user_post.user_post_comments.new(session[:user_post_comment_attributes])
      clear_user_post_comment_session
    else
      @user_post_comment = @user_post.user_post_comments.new
    end
  end

  def new
    @form_action_url = user_posts_path(@user)
    @form_method = :post
    @user_post = @user.user_posts.new(user_post_attributes_from_session)
  end

  # AIのタグ付けAPIを使用しないバージョン
  # def create
  #   @user_post = current_user.user_posts.new(user_post_params)

  #   if @user_post.save 
  #     # 投稿成功 → 最終投稿日時を更新
  #     @user.update(last_user_posted_at: Time.current)
  #     redirect_to user_post_path(@user, @user_post), notice: '投稿が作成されました'
  #   else
  #     Form::DataStorageService.store(session: session, flash: flash, attributes: user_post_params, 
  #       error_messages: @user_post.errors.full_messages, error_name: '投稿', 
  #         key: :user_post_attributes)
  #     redirect_to new_user_post_path(@user)
  #   end
  # end 

  # AIのタグ付けAPIを使用するバージョン
  def create
    @user_post = @user.user_posts.new(user_post_params)

    image_file = user_post_params[:user_post_image]

    if image_file.present?
      # Vision.get_image_dataに画像の情報を渡す
      tags = Vision.get_image_data(user_post_params[:user_post_image]) 
      @user_post.tag_list.add(tags)
    end

    if @user_post.save
      # 投稿成功 → 最終投稿日時を更新
      @user.update(last_user_posted_at: Time.current)
      redirect_to user_post_path(@user, @user_post), notice: '投稿を作成しました'
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: user_post_params, 
        error_messages: @user_post.errors.full_messages, error_name: '投稿', 
          key: :user_post_attributes)
      redirect_to new_user_post_path(@user)
    end
  end

  def edit
    @form_action_url = user_post_path(@user, @user_post)
    @form_method = :patch
    if session[:user_post_attributes]
      @user_post.assign_attributes(session[:user_post_attributes])
      clear_user_post_session
    end
  end
  
  def update
    if @user_post.update(user_post_params)
      redirect_to user_post_path(@user, @user_post), notice: '投稿を更新しました'
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: user_post_params, 
        error_messages: @user_post.errors.full_messages, error_name: '投稿の更新', 
          key: :user_post_attributes)
      redirect_to edit_user_post_path(@user, @user_post)
    end
  end
  
  def destroy
    begin
      Deleter::UserPostDeleter.new(@user_post, deleted_by: current_user, 
        deleted_reason: :self_deleted).call
      redirect_to user_posts_path(@user), notice: '投稿を削除しました'
    rescue => e
      Rails.logger.error("UserPost削除エラー: #{e.message}")
      redirect_to user_posts_path(@user), alert: '予期せぬエラーにより、投稿の削除が行えませんでした'
    end
  end

  private

  # ユーザーを取得
  def set_user
    @user = User.active_users.find(params[:user_id])
  end

  # 投稿を取得
  def set_user_post
    @user_post = @user.user_posts.active_post.find(params[:id])
  end

  def user_post_attributes_from_session
    data = session[:user_post_attributes]
    clear_user_post_session if data.present?
    data || {}
  end

  def clear_user_post_session
    session.delete(:user_post_attributes)
  end
    
  def clear_user_post_comment_session
    session.delete(:user_post_comment_attributes)
  end

  def user_post_params
    params.require(:user_post).permit(:user_post_image, :title, :body)
  end
end