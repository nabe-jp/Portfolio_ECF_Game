class Public::UserController < ApplicationController
  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Public::PlaceholdersHelper
  
  before_action :authenticate_user!
  before_action :set_current_user, only: [:show, :edit, :update, :mypage, :settings, :check, :withdraw]
  before_action :set_user_posts, only: [:show]
  before_action :set_groups, only: [:show]
  
  def show; end

  def edit
    # エラー時にはセッションからユーザーの入力内容を再設定
    if session[:user_attributes]
      @user.assign_attributes(session[:user_attributes])
      clear_user_session
    end
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_user_path, notice: 'ユーザー情報を更新しました'
    else
      # 機密性もなく、長文を取り扱う可能性もあるためセッションに保存
      Form::DataStorageService.store(session: session, flash: flash, 
        attributes: @user.attributes.slice("nickname", "bio"), 
          error_messages: @user.errors.full_messages, error_name: '公開プロフィールの更新', 
            key: :user_attributes)
      redirect_to edit_user_path and return
    end
  end

  # === 以下、カスタムアクション ===

  # 自身の詳細ページ
  def mypage; end

  # 自身の設定一覧ページ
  def settings; end

  # 退会確認画面
  def check; end

  # 退会処理
  def withdraw
    begin
      Deleter::UserDeleter.new(current_user, deleted_by: current_user, 
        deleted_reason: :self_deleted, deleted_by_type: :user).call
      reset_session
      redirect_to root_path, notice: '退会処理を完了しました'
    rescue => e
      Rails.logger.error("User削除エラー: #{e.message}")
      redirect_to root_path, alert: '予期せぬエラーにより、退会処理が行えませんでした'
    end
  end

  private

  # ユーザー情報を取得
  def set_current_user
    @user = current_user
  end

  def set_user_posts
    @user_posts = @user.user_posts.active_posts_desc.page(params[:page])
  end

  def set_groups
    @groups = @user.active_joined_groups
      .merge(Group.active_groups_desc).page(params[:joined_page]).per(5)
  end

  def clear_user_session
    session.delete(:user_attributes)
  end

  def user_params
    params.require(:user).permit(:profile_image, :nickname, :bio)
  end
end