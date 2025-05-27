class Public::GroupMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def join
    membership = GroupMembership.new(user: current_user, group: @group)

    if membership.persisted?
      redirect_to group_path(@group), notice: "すでに参加しています。"
    elsif membership.save
      redirect_to group_path(@group), notice: "グループに参加しました。"
    else
      redirect_to group_path(@group), alert: "参加に失敗しました。"
    end
  end

  def leave
    membership = GroupMembership.find_by(user: current_user, group: @group)
    
    if membership&.destroy
      redirect_to group_path(@group), notice: 'グループを退出しました。'
    else
      redirect_to group_path(@group), alert: '退出できませんでした。'
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end