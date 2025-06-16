class Admin::Groups::GroupMembersController < Admin::ApplicationController
  include Admin::Publishable

  before_action :set_group
  before_action :set_group_member, only: [:show, :destroy, :reactivate, :update_role, :update_note]

  def index
    @group_members = @group.group_memberships.includes(:user).where(is_deleted: false).order(:created_at)
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しメンバーとメンバーに紐づけて論理削除を行う
      Deleter::GroupMemberDeleter.new(@group_member, deleted_by: current_user, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_members_path(@group), notice: 'メンバーを削除しました'
    rescue => e
      Rails.logger.error("GroupMember削除エラー: #{e.message}")
      redirect_to admin_group_members_path(@group), 
        alert: '予期せぬエラーにより、メンバーの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupMemberRestorer.new(@group, @group_member).call
      redirect_to admin_group_member_path(@group, @group_member), notice: 'メンバーを復元しました'
    rescue => e
      Rails.logger.error("GroupMember復元エラー: #{e.message}")
      redirect_to admin_group_member_path(@group, @group_member), 
        alert: '予期せぬエラーにより、メンバーの復元が行えませんでした。'
    end
  end

  def update_role
    if @group_member.update(role: params[:role])
      redirect_to admin_group_member_path(@group, @group_member), notice: '役割を更新しました。'
    else
      redirect_to admin_group_member_path(@group, @group_member), alert: '役割の更新に失敗しました。'
    end
  end

  def update_note
    if @group_member.update(note: params[:note])
      redirect_to admin_group_member_path(@group, @group_member), notice: 'ノートを更新しました。'
    else
      redirect_to admin_group_member_path(@group, @group_member), alert: 'ノートの更新に失敗しました。'
    end
  end
  
  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupMembers.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_member
    @group_member = @group.group_memberships.find(params[:id])
  end
end
