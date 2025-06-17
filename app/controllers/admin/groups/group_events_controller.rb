class Admin::Groups::GroupEventsController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_group
  before_action :set_group_event, only: [:show, :destroy, :reactivate]

  def index
    @group_events = filtered_records(@group.group_events).order(*sort_order).page(params[:page])
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しイベントの論理削除を行う
      Deleter::GroupEventDeleter.new(@group_event, deleted_by: current_admin, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_event_path(@group.id, @group_event), notice: "イベントを削除しました。"
    rescue => e
      Rails.logger.error("GroupEvent削除エラー: #{e.message}")
      redirect_to admin_group_event_path(@group.id, @group_event), 
        alert: '予期せぬエラーにより、イベントの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupEventRestorer.new(@group_event).call
      redirect_to admin_group_event_path(@group.id, @group_event), notice: 'イベントを復元しました'
    rescue => e
      Rails.logger.error("GroupEvent復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした。'
      redirect_to admin_group_event_path(@group.id, @group_event)
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