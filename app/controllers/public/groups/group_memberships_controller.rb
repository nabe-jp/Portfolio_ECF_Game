class Public::Groups::GroupMembershipsController < ApplicationController
  include ::Public::Concerns::AuthorizeGroup

  before_action :authenticate_user!

  def join
    membership = GroupMembership.find_by(user: current_user, group: @group)
  
    if membership&.is_deleted == false
      redirect_to group_path(@group), notice: "すでに参加しています。"
    # 過去に参加していた場合
    elsif membership&.is_deleted == true
      # キックされていたら復帰不可
      if membership.deleted_reason == "kicked_by_group_owner"
        redirect_to group_path(@group), alert: "このグループから追放されているため、再度参加できません。"
      else
        membership.update(is_deleted: false, deleted_at: nil, deleted_by_id: nil, 
          deleted_reason: nil, joined_at: Time.current)
        redirect_to group_path(@group), notice: "グループに復帰しました。"
      end
    else
      membership = GroupMembership.new(user: current_user, group: @group, joined_at: Time.current)
      if membership.save
        redirect_to group_path(@group), notice: "グループに参加しました。"
      else
        redirect_to group_path(@group), alert: "参加に失敗しました。"
      end
    end
  end  

  def leave
    membership = GroupMembership.find_by(user: current_user, group: @group)
  
    if membership&.update(is_deleted: true, deleted_at: Time.current, deleted_by_id: current_user.id,
      deleted_reason: :voluntarily_left)
      redirect_to group_path(@group), notice: 'グループを退出しました。'
    else
      redirect_to group_path(@group), alert: '退出できませんでした。'
    end
  end
end