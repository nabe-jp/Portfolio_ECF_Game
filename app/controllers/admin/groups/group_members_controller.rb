class Admin::Groups::GroupMembersController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  helper Admin::Groups::GroupMembersHelper
  
  before_action :set_group
  before_action :set_group_member, only: [:show, :destroy, :reactivate, :update_role, :update_note]

  def index
    @members = @group.group_memberships.includes(:user)
  
    if params[:visibility] == "public"
      @members = @members.unhidden_only
    elsif params[:visibility] == "private"
      @members = @members.hidden_only
    end
  
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction].to_sym : :desc
  
    @group_members = filtered_records_for_enum_status(@members)
      .order(created_at: direction, id: direction)
      .page(params[:page])
  
    @type = params[:type].presence || "member"
  end  

  def show; end

  def destroy
    begin
      # サービスオブジェクトを呼び出しメンバーとメンバーに紐づけて論理削除を行う
      Deleter::GroupMemberDeleter.new(@group_member, deleted_by: current_admin, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_member_path(@group.id, @group_member), notice: 'メンバーを削除しました'
    rescue => e
      Rails.logger.error("GroupMember削除エラー: #{e.message}")
      redirect_to admin_group_member_path(@group.id, @group_member), 
        alert: '予期せぬエラーにより、メンバーの削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupMemberRestorer.new(@group_member).call
      redirect_to admin_group_member_path(@group.id, @group_member), notice: 'メンバーを復元しました'
    rescue => e
      Rails.logger.error("GroupMember復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした。'
      redirect_to admin_group_member_path(@group.id, @group_member)
    end
  end
  
  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupMembership.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_member
    @group_member = @group.group_memberships.find(params[:id])
  end
end
