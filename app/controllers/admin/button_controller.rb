class Admin::ButtonController < Admin::ApplicationController
  def test
    @user = current_user
  end
end