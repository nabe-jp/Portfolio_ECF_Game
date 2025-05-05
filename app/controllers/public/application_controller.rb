class Public::ApplicationController < ApplicationController
  before_action :active_check

  private

  # ログインしているアカウントが退会済みのアカウントの場合、トップページにリダイレクトする
  def active_check
    if customer_signed_in? && !current_customer.is_active
      sign_out(current_customer)
      flash[:alert] = "退会済みアカウントの為、使用できません"
      redirect_to root_path and return    # returnを使い処理を確実に終え、安定性を高める
    end
  end
end