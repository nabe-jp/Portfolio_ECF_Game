class Public::Groups::GroupDashboardController < Public::ApplicationController
  include ::Public::Concerns::AuthorizeGroup

  def show
    @group_events = active_scope_asc(@group.group_events)
    @group_notices  = active_scope_desc(@group.group_notices)
    @members = active_scope_desc(@group.members)
    @group_posts = active_scope_desc(@group.group_posts)
  end
end