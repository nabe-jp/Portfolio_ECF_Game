class Public::GroupEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_group_member!
  before_action :set_group
  before_action :set_group_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = @group.group_events.where(is_deleted: false).order(start_time: :asc)
  end

  def show; end

  def new
    @group_event = @group.group_events.new
  end

  def create
    @group_event = @group.group_events.build(group_event_params)
    @group_event.user = current_user

    if @group_event.save
      redirect_to dashboard_group_path(@group), notice: 'イベントを作成しました。'
    else
      flash.now[:alert] = 'イベントの作成に失敗しました'
      render :new
    end
  end

  def edit ; end

  def update
    if @group_event.update(group_event_params)
      redirect_to dashboard_group_path(@group), notice: 'イベントを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @group_event.update(is_deleted: true, deleted_at: Time.current, deleted_by_id: current_user.id)
    redirect_to dashboard_group_path(@group), alert: 'イベントを削除しました'
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_event
    @group_event = @group.group_events.find(params[:id])
  end

  def authorize_group_member!
    unless @group.members.include?(current_user)
      redirect_to groups_path, alert: 'このグループのメンバーのみアクセスできます。'
    end
  end

  def group_event_params
    params.require(:group_event).permit(:title, :description, :start_time, :end_time, :is_public)
  end
end