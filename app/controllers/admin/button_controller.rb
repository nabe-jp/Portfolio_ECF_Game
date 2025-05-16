class Admin::ButtonController < ApplicationController
  def test
    @user = current_user
  end
end