class Admin::GroupPostsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  
  def index
  end

  def show
  end

  def destroy
  end
end
