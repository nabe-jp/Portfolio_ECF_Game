class Public::Groups::GroupMembersController < Public::ApplicationController
  include Public::AuthorizeGroup

  # 読み込んだモジュール(AuthorizeGroup)のメソッドをviewで使用する為に必要
  helper_method :group_owner?, :group_moderator?

  before_action :authorize_group_member!
  before_action :authorize_group_moderator!, only: [:destroy, :edit_note, :update_note, :update_role]
  before_action :set_membership, only: [:show, :destroy, :edit_note, :update_note, :update_role]

  def index
    @memberships = @group.active_group_memberships
      .joins(:user).merge(User.active_users_desc).includes(:user)
  
    @owner_memberships = @memberships.where(role: :owner)
    @moderator_memberships = @memberships.where(role: :moderator)
    @member_memberships = @memberships.where(role: :member)
  end

  def show
    if session[:group_membership_attributes]
      @membership.assign_attributes(session[:group_membership_attributes])
      clear_group_membership_session
    end
  end
  
  def destroy
    # 自分より上または同等の権限の人には変更不可
    return if prohibit_operating_higher_or_equal_role!(@membership)
    
    begin
      # サービスオブジェクトをにてグループとグループに紐づくものを論理削除
      Deleter::GroupMemberDeleter.new(@membership, 
        deleted_by: current_user, deleted_reason: :kicked_by_group_moderator).call
      redirect_to group_members_path(@group), notice: "メンバーを追放しました"
    rescue => e
      Rails.logger.error("GroupMember追放エラー: #{e.message}")
      redirect_to group_dashboard_path(@group), alert: '予期せぬエラーにより、メンバーの追放が行えませんでした。'
    end
  end

  def edit_note
    @form_url = update_note_group_member_path(@group, @membership)
    if session[:group_membership_attributes]
      @membership.assign_attributes(session[:group_membership_attributes])
      clear_group_membership_session
    end
  end

  def update_note
    if @membership.update(params.require(:group_membership).permit(:note))
      redirect_to group_member_path(@group, @membership), notice: "メモを更新しました"
    else
      Form::DataStorageService.store(session: session, flash: flash, 
        attributes: group_membership_params, error_messages: @membership.errors.full_messages, 
          error_name: 'メモの更新', key: :group_membership_attributes)
      redirect_to edit_note_group_member_path(@group, @membership)
    end
  end

  def update_role
    @membership = @group.group_memberships.find(params[:id])
    new_role = params.require(:group_membership).permit(:role)[:role]
  
    # オーナー権限を譲渡する場合
    if new_role == "owner"
      unless group_owner?
        return redirect_to group_member_path(@group, @membership), 
          alert: "オーナーの指名はオーナー本人のみ可能です。"
      end
  
      ActiveRecord::Base.transaction do
        previous_owner = @group.group_memberships.find_by(role: "owner")
        previous_owner.update!(role: "moderator") if previous_owner != @membership
  
        @membership.update!(role: "owner")
        @group.update!(owner_id: @membership.user_id)

        @group.reload 
      end
  
      return redirect_to group_member_path(@group, @membership), notice: "オーナーを移譲しました"
    end
  
    # 自分より上または同等の権限の人には変更不可
    return if prohibit_operating_higher_or_equal_role!(@membership)
  
    # 自分より上の権限を付与するのは不可
    return if prohibit_assigning_higher_role!(new_role)
  
    if @membership.update(role: new_role)
      redirect_to group_member_path(@group, @membership), notice: "役職を変更しました"
    else
      redirect_to group_member_path(@group, @membership), 
        alert: "役職の変更の変更が出来ませんでした"
    end
  end  

  private
  
  def set_membership
    @membership = @group.group_memberships.active_members.find(params[:id])
  end

  def clear_group_membership_session
    session.delete(:group_membership_attributes)
  end

  def group_membership_params
    params.require(:group_membership).permit(:role, :note)
  end
end
