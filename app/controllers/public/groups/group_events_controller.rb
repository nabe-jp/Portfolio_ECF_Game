class Public::Groups::GroupEventsController < ApplicationController
  include ::Public::Concerns::AuthorizeGroup

  before_action :authenticate_user!
  before_action :authorize_group_member!
  before_action :authorize_group_moderator!, only: [:edit, :update, :destroy]
  before_action :set_group_event, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user, only: [:create]

  def index
    @events = if @group.owner == current_user
      # 管理者：新着順（最新の作成日時が上に来る）
      @group.group_events.active_group_info.order(created_at: :desc)
    else
      # メンバー：開催日が近い順(upcomingスコープ)
      @group.group_events.active_group_info.upcoming
    end

    @events = @events.page(params[:page]).per(10)
  end

  def show; end

  def new
    @form_url = group_events_path(@group)
    @group_event = @group.group_events.new(group_event_attributes_from_session)
  end

  def create
    @group_event = @group.group_events.build(group_event_params)
    @group_event.member = @group_membership

    if @group_event.save
      session[:group_event_attributes] = nil
      redirect_to group_events_path(@group), notice: 'イベントを作成しました。'
    else
      store_form_data(attributes: group_event_params, 
        error_messages: @group_event.errors.full_messages, error_name: "イベントの作成")
      redirect_to new_group_event_path(@group)
    end
  end

  def edit
    @form_url = group_event_path(@group, @group_event)
    if session[:group_event_attributes]
      @group_event.assign_attributes(session[:group_event_attributes])
      session.delete(:group_event_attributes)
    end
  end

  def update
    if @group_event.update(group_event_params)
      session.delete(:group_event_attributes)
      redirect_to group_events_path(@group), notice: 'イベントを更新しました'
    else
      store_form_data(attributes: group_event_params, error_messages: @group_event.errors.full_messages)
      redirect_to edit_group_event_path(@group, @group_event)
    end
  end

  def destroy
    begin
      Deleter::GroupEventDeleter.call(@group_event, deleted_by: current_user)
      redirect_to group_events_path(@group),
      notice: "イベントを削除しました"
    rescue => e
      Rails.logger.error("イベント削除エラー: #{e.message}")
      redirect_to group_events_path(@group), alert: '予期せぬエラーにより、イベントの削除が行えませんでした。'
    end
  end

  private

  def set_group_event
    @group_event = @group.group_events.find(params[:id])
  end
  
  def set_current_user
    @group_membership = @group.group_memberships.find_by(user_id: current_user.id)
  end


  def group_event_attributes_from_session
    session[:group_event_attributes] || {}
  end

  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "イベントの更新"
    session[:group_event_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def group_event_params
    params.require(:group_event).permit(:title, :description, :start_time, :end_time, :is_pinned)
  end
end