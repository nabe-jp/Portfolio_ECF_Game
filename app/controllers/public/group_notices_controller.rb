class Public::GroupNoticesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :ensure_group_member!
  before_action :set_group_notice, only: [:show, :edit, :update, :destroy]

  def index
    @notices = @group.group_notices.active.order(created_at: :desc)
  end

  def show; end

  def new
    @group_notice = @group.group_notices.new
  end

  def create
    @group_notice = @group.group_notices.build(group_notice_params)
    @group_notice.user = current_user

    if @group_notice.save
      redirect_to dashboard_group_path(@group), notice: "お知らせを作成しました。"
    else
      flash.now[:alert] = "お知らせの作成に失敗しました。"
      render :new
    end
  end

  def edit; end

  def update
    if @group_notice.update(group_notice_params)
      redirect_to dashboard_group_path(@group), notice: "お知らせを更新しました。"
    else
      flash.now[:alert] = "お知らせの更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @group_notice.soft_delete(current_user.id)
    redirect_to dashboard_group_path(@group), alert: "お知らせを削除しました。"
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_notice
    @group_notice = @group.group_notices.find(params[:id])
  end

  def ensure_group_member!
    unless @group.members.include?(current_user)
      redirect_to groups_path, alert: "このグループのメンバーのみアクセスできます。"
    end
  end

  def group_notice_params
    params.require(:group_notice).permit(:title, :body, :is_public)
  end
end
