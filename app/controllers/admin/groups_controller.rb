class Admin::GroupsController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_group, only: [:show, :destroy, :reactivate, :publish, :hide]

  def index
    @groups = filtered_records(Group).order(*sort_order).page(params[:page])
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しグループとグループに紐づけて論理削除を行う
      Deleter::GroupDeleter.new(@group, deleted_by: current_admin, deleted_reason: :removed_by_admin).call
      redirect_to admin_group_path(@group.id), notice: 'グループを削除しました'
    rescue => e
      Rails.logger.error("Group削除エラー: #{e.message}")
      redirect_to admin_group_path(@group.id), 
        alert: '予期せぬエラーにより、グループの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupRestorer.new(@group).call
      redirect_to admin_group_path(@group.id), notice: 'グループを復元しました'
    rescue => e
      Rails.logger.error("Group復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした。'
      redirect_to admin_group_path(@group.id)
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = Group.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end