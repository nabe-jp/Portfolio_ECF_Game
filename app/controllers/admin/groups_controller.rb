class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  end

  def show
  end

  def destroy
  end
end
