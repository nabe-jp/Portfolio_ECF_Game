class Admin::GroupsController < Admin::ApplicationController
  include Admin::Publishable

  before_action :set_group, only: [:show, :destroy, :reactivate, :publish, :hide]

  def index
    @groups = Group.created_desc
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しグループとグループに紐づけて論理削除を行う
      Deleter::GroupDeleter.new(@group, deleted_by: current_user, deleted_reason: :removed_by_admin).call
      redirect_to admin_groups_path, notice: 'グループを削除しました'
    rescue => e
      Rails.logger.error("Group削除エラー: #{e.message}")
      redirect_to admin_groups_path, alert: '予期せぬエラーにより、グループの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupRestorer.new(@group).call
      redirect_to admin_group_path(@group), notice: 'グループを復元しました'
    rescue => e
      Rails.logger.error("Group復元エラー: #{e.message}")
      redirect_to admin_group_path(@group), alert: '予期せぬエラーにより、グループの復元が行えませんでした。'
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupPost.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end