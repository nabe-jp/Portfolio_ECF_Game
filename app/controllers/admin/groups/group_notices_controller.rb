class Admin::Groups::GroupNoticesController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_group
  before_action :set_group_notice, only: [:show, :destroy, :reactivate]

  def index
    @group_notices = filtered_records(@group.group_notices).order(*sort_order).page(params[:page])
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しお知らせの論理削除を行う
      Deleter::GroupNoticeDeleter.new(@group_notice, deleted_by: current_admin, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_notice_path(@group.id, @group_notice), notice: 'お知らせを削除しました'
    rescue => e
      Rails.logger.error("GroupNotice削除エラー: #{e.message}")
      redirect_to admin_group_notice_path(@group.id, @group_notice), 
        alert: '予期せぬエラーにより、お知らせの削除が行えませんでした'
    end
  end

  def reactivate
    begin
      Restorer::GroupNoticeRestorer.new(@group_notice).call
      redirect_to admin_group_notice_path(@group.id, @group_notice), notice: 'お知らせを復元しました'
    rescue => e
      Rails.logger.error("GroupNotice復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした'
      redirect_to admin_group_notice_path(@group.id, @group_notice)
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupNotice.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_notice
    @group_notice = @group.group_notices.find(params[:id])
  end
end