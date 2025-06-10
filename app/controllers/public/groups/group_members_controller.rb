class Public::Groups::GroupMembersController < Public::ApplicationController
  include ::Public::Concerns::AuthorizeGroup

  before_action :authorize_group_member!
  before_action :authorize_group_owner!, only: [:edit_note, :destroy, :update_note, :update_role]
  before_action :set_membership, only: [:show, :edit_note, :destroy, :update_note, :update_role]

  def index
    @memberships = @group.group_memberships
    .joins(:user).merge(User.active_users_desc).includes(:user)
  
    @owner_memberships = @memberships.select(&:owner?)
    @moderator_memberships = @memberships.select(&:moderator?)
    @member_memberships = @memberships.select(&:member?)
  end

  def show
    if session[:membership_attributes]
      @membership.assign_attributes(session[:membership_attributes])
      session.delete(:membership_attributes)
    end
  end
  
  def destroy
    begin
      # サービスオブジェクトをにてグループとグループに紐づくものを論理削除
      Deleter::GroupMemberDeleter.call(@membership, 
        deleted_by: current_user, deleted_reason: :kicked_by_group_owner)
      redirect_to group_members_path(@group), notice: "メンバーを追放しました"
    rescue => e
      Rails.logger.error("メンバー追放エラー: #{e.message}")
      redirect_to group_dashboard_path(@group), alert: '予期せぬエラーにより、メンバーの追放が行えませんでした。'
    end
  end


  def edit_note; end

  def update_note
    if @membership.update(params.require(:group_membership).permit(:note))
      redirect_to group_member_path(@group, @membership), notice: "メモを更新しました"
    else
      store_form_data(attributes: params[:group_membership], error_messages: @membership.errors.full_messages, error_name: "メモ更新")
      redirect_to group_member_path(@group, @membership)
    end
  end

  def update_role
    if @membership.update(params.require(:group_membership).permit(:role))
      redirect_to group_member_path(@group, @membership), notice: "役職を変更しました"
    else
      store_form_data(attributes: params[:group_membership], error_messages: @membership.errors.full_messages, error_name: "役職変更")
      redirect_to group_member_path(@group, @membership)
    end
  end

  private
  
  def set_membership
    @membership = @group.group_memberships.find(params[:id])
  end

  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "更新"
    session[:membership_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def role_params
    params.require(:group_membership).permit(:role, :note)
  end
end
