class Public::Groups::GroupDashboardController < Public::ApplicationController
  include Public::AuthorizeGroup
  
  def show
    # @group_events = active_scope_asc(@group.group_events)
    # @group_notices  = active_scope_desc(@group.group_notices)
    # @members = active_scope_desc(@group.members)
    # @group_posts = active_scope_desc(@group.group_posts)
    @group_events = @group.group_events.active_events_for_moderators
    @group_notices = @group.group_notices.active_group_notices_not_pinned
    @members = @group.members.active_users_desc
    @group_posts = @group.group_posts.active_group_posts_for_members_desc
  end
end