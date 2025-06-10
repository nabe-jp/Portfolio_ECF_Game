class Public::ApplicationController < ApplicationController
  # ActiveRecordのRecordNotFoundが発生したらこのメソッドを呼ぶ
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :active_check

  private

  # RecordNotFoundが発生後の処理
  def render_not_found
    flash[:alert] = "ページが見つかりません"
    redirect_to root_path and return
  end

  # ログインしているアカウントが退会済みのアカウントの場合、トップページにリダイレクトする
  def active_check
    if user_signed_in? && !current_user.active?
      sign_out(current_user)
      flash[:alert] = "退会済みアカウントの為、使用できません"
      redirect_to root_path and return    # returnを使い処理を確実に終え、安定性を高める
    end
  end
end