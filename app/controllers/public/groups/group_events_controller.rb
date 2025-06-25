class Public::Groups::GroupEventsController < Public::ApplicationController
  include Public::AuthorizeGroup

  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Public::PlaceholdersHelper

  # 読み込んだモジュール(AuthorizeGroup)のメソッドをviewで使用する為に必要
  helper_method :group_event_editor?

  before_action :authenticate_user!
  before_action :authorize_group_member!
  before_action :set_group_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_group_event_editor!, only: [:edit, :update, :destroy]
  before_action :set_current_user, only: [:create]

  def index
    # 管理者のみすべて見える(投稿者本人も終わったイベントは見えない)
    if group_moderator?
      @group_events = @group.group_events.active_events_for_moderators.page(params[:page])
    else
      @group_events = @group.group_events.active_events_for_members.page(params[:page])
    end
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
      redirect_to group_events_path(@group), notice: 'イベントを作成しました。'
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: group_event_params, 
        error_messages: @group_event.errors.full_messages, error_name: 'イベントの作成', 
          key: :group_event_attributes)
      redirect_to new_group_event_path(@group)
    end
  end

  def edit
    @form_url = group_event_path(@group, @group_event)
    if session[:group_event_attributes]
      @group_event.assign_attributes(session[:group_event_attributes])
      clear_group_event_session
    end
  end

  def update
    if @group_event.update(group_event_params)
      redirect_to group_events_path(@group), notice: 'イベントを更新しました'
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: group_event_params, 
        error_messages: @group_event.errors.full_messages, error_name: 'イベントの更新', 
          key: :group_event_attributes)
      redirect_to edit_group_event_path(@group, @group_event)
    end
  end

  def destroy
    # イベントを投稿したユーザーかグループ管理者かの判定
    if @group_event.member.user == current_user
      deleted_reason = :self_deleted
    else
      deleted_reason = :removed_by_group_authority
    end

    begin
      Deleter::GroupEventDeleter.new(@group_event, deleted_by: current_user, 
        deleted_reason: deleted_reason).call
      redirect_to group_events_path(@group), notice: "イベントを削除しました"
    rescue => e
      Rails.logger.error("GroupEvent削除エラー: #{e.message}")
      redirect_to group_events_path(@group), alert: '予期せぬエラーにより、イベントの削除が行えませんでした。'
    end
  end

  private

  def set_group_event
    # 管理者のみすべて見える(投稿者本人も終わったイベントは見えない)
    if group_moderator?
      @group_event = @group.group_events.active_events_for_moderators.find(params[:id])
    else
      @group_event = @group.group_events.active_events_for_members.find(params[:id])
    end
  end
  
  def set_current_user
    @group_membership = @group.group_memberships.active_members.find_by(user_id: current_user.id)
  end

  def group_event_attributes_from_session
    data = session[:group_event_attributes]
    clear_group_event_session if data.present?
    data || {}
  end

  def clear_group_event_session
    session.delete(:group_event_attributes)
  end

  def group_event_params
    params.require(:group_event).permit(:title, :description, :start_time, :end_time, :is_pinned)
  end
end