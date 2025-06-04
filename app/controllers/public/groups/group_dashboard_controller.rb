class Public::Groups::GroupDashboardController < ApplicationController
  before_action :set_group

  def show
    @group_posts    = @group.group_posts.where(is_deleted: false).order(created_at: :desc)
    @group_events   = @group.group_events.where(is_deleted: false).order(start_time: :asc)
    @group_notices  = @group.group_notices.where(is_deleted: false).order(created_at: :desc)
    @members        = @group.members
  end

  private

  def set_group
    @group = Group.find_by!(slug: params[:group_slug])
  end
end