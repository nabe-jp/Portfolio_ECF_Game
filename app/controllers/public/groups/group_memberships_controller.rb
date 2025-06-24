class Public::Groups::GroupMembershipsController < Public::ApplicationController
  include Public::AuthorizeGroup

  before_action :authenticate_user!
  before_action :authorize_group_moderator!, only:[:approve, :reject]

  
  def index
    @pending_memberships = @group.group_memberships.includes(:user).pending_members
      .order(created_at: :desc)
  end

  # groupのshowアクションのボタンから実行される、showアクションで有効なメンバーはダッシュボードに遷移している
  def join
    membership = GroupMembership.find_by(user: current_user, group: @group)
  
    if membership&.id
      if membership.member_status_rejected?
        redirect_to group_path(@group), alert: '参加申請が却下されているため、再度申請することはできません。'
  
      elsif membership.member_status_inactive?
        # 復帰処理
        membership.assign_attributes(member_status: :active, deleted_at: nil, deleted_by_id: nil,
          deleted_reason: nil, joined_at: Time.current, role: :member)
        if membership.save
          redirect_to group_dashboard_path(@group), notice: 'グループに復帰しました。'
        else
          redirect_to group_path(@group), alert: '復帰に失敗しました。'
        end

      elsif membership.member_status_kicked? || membership.member_status_suspended?
        redirect_to group_path(@group),
          alert: 'このグループから追放または利用停止となっているため、参加できません。'

      # アクティブでもサイト管理者により非公開になっている場合(個別非公開や連鎖復元)がある
      elsif membership.member_status_active? && 
        (!membership.is_public? || membership.hidden_on_parent_restore?)
        redirect_to group_path(@group), 
          alert: 'このグループに参加していますがあなたのステータスが制限されているため利用できません。'

      else
        redirect_to group_path(@group), alert: '参加できませんでした。'
      end
    else
      membership = GroupMembership.new(user: current_user, group: @group, role: :member, 
        member_status: :pending)
      if membership.save
        redirect_to group_path(@group), notice: 'グループに参加申請を送りました。'
      else
        redirect_to group_path(@group), alert: '参加申請を送ることに失敗しました。'
      end
    end
  end

  def leave
    membership = GroupMembership.find_by(user: current_user, group: @group)

    if membership.nil?
      redirect_to group_path(@group), alert: 'グループメンバーではありません。'
      return
    end
    
    if membership.update(member_status: :inactive, deleted_at: Time.current,
      deleted_by_id: current_user.id, deleted_reason: :voluntarily_left_group,
        role: :member)
      redirect_to group_path(@group), notice: 'グループを退出しました。'
    else
      redirect_to group_path(@group), alert: '退出できませんでした。'
    end
  end

  def approve
    membership = @group.group_memberships.find(params[:id])
  
    if membership.member_status_pending?
      if membership.update(member_status: :active, approved_at: Time.current,
        approved_by_id: current_user.id, joined_at: Time.current)
        redirect_to group_members_path(@group), notice: '参加申請を承認しました。'
      else
        redirect_to group_memberships_path(@group), alert: '参加申請の承認に失敗しました。'
      end
    else
      redirect_to group_memberships_path(@group), alert: '承認できる申請ではありません。'
    end
  end

  def reject
    membership = @group.group_memberships.find(params[:id])

    if membership.member_status_pending?
      if membership.update(member_status: :rejected, deleted_reason: :application_rejected,
        deleted_at: Time.current, deleted_by_id: current_user.id)
        redirect_to group_memberships_path(@group), notice: '参加申請を却下しました。'
      else
        redirect_to group_memberships_path(@group), alert: '参加申請の却下に失敗しました。'
      end
    else
      redirect_to group_memberships_path(@group), alert: '却下できる申請ではありません。'
    end
  end

  def cancel
    membership = GroupMembership.find_by(user: current_user, group: @group)
  
    if membership&.member_status_pending?
      if membership.destroy
        redirect_to group_path(@group), notice: '参加申請をキャンセルしました。'
      else
        redirect_to group_path(@group), alert: '参加申請キャンセルに失敗しました。'
      end
    else
      redirect_to group_path(@group), alert: 'キャンセル可能な申請が見つかりません。'
    end
  end  
end