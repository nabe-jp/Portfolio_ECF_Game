class Admin::InformationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_information, only: [:edit, :update]

  def new
    @information = Information.new
  end

  def create
    @information = Information.new(information_params)
    @information.admin = current_admin
    if @information.save
      redirect_to admin_root_path, notice: "お知らせを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @information = Information.find(params[:id])
  end

  def update
    @information = Information.find(params[:id])
    if @information.update(information_params)
      redirect_to admin_root_path, notice: "お知らせを更新しました。"
    else
      render :edit
    end
  end

  private

  def set_information
    @information = Information.find(params[:id])
  end

  def information_params
    params.require(:information).permit(:title, :body, :published_at, :visible, :pinned)
  end
end
