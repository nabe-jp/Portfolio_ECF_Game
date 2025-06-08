class Public::ApplicationController < ApplicationController
  before_action :active_check

  protected

  def active_scope_asc(scope)
    scope.where(is_deleted: false, is_public: true).order(created_at: :asc)
  end

  def active_scope_desc(scope)
    scope.where(is_deleted: false, is_public: true).order(created_at: :desc)
  end

  private

  # ログインしているアカウントが退会済みのアカウントの場合、トップページにリダイレクトする
  def active_check
    if user_signed_in? && current_user.active?
      sign_out(current_customer)
      flash[:alert] = "退会済みアカウントの為、使用できません"
      redirect_to root_path and return    # returnを使い処理を確実に終え、安定性を高める
    end
  end
end