class Admin::Groups::GroupEventsController < Admin::ApplicationController
  include Admin::Publishable

  before_action :set_group
  before_action :set_group_event, only: [:show, :destroy, :reactivate]

  def index
    @group_events = @group.group_events.where(is_deleted: false).order(start_time: :desc)
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しイベントの論理削除を行う
      Deleter::GroupEventDeleter.new(@group_event, deleted_by: current_user, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_events_path(@group), notice: "イベントを削除しました。"
    rescue => e
      Rails.logger.error("GroupEvent削除エラー: #{e.message}")
      redirect_to admin_group_events_path(@group), 
        alert: '予期せぬエラーにより、イベントの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupEventRestorer.new(@group, @group_event).call
      redirect_to admin_group_event_path(@group, @group_event), notice: 'イベントを復元しました'
    rescue => e
      Rails.logger.error("GroupEvent復元エラー: #{e.message}")
      redirect_to admin_group_event_path(@group, @group_event), 
        alert: '予期せぬエラーにより、イベントの復元が行えませんでした。'
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupEvent.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_event
    @group_event = @group.group_events.find(params[:id])
  end
end