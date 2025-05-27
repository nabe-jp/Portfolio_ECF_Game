class Public::UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: [:show, :edit, :update, :mypage, :settings, :check, :withdraw]

  def show; end

  def edit
    # エラー時にはセッションからユーザーの入力内容を再設定
    if session[:user_attributes]
      @user.assign_attributes(session[:user_attributes])
      session.delete(:user_attributes)
    end
  end

  def update
    if @user.update(user_params)
      session.delete(:user_attributes)
      redirect_to mypage_user_path, notice: "ユーザー情報を更新しました。"
    else
      # 機密性もなく、長文を取り扱う可能性もあるためセッションに保存
      session[:user_attributes] = @user.attributes.slice("nickname", "bio")
      flash[:error_name] = "パスワード更新"
      flash[:error_messages] = @user.errors.full_messages
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
      Deleter::UserDeleter.call(current_user, deleted_by: current_user)
      reset_session
      redirect_to root_path, notice: "退会処理を完了しました。"
    rescue => e
      redirect_to root_path, alert: '予期せぬエラーにより、退会処理が行えませんでした。'
    end
  end

  private

  # ユーザー情報を取得
  def set_current_user
    @user = current_user
  end

  # ユーザーパラメータの制御
  def user_params
    params.require(:user).permit(:profile_image, :nickname, :bio, :is_active)
  end
end