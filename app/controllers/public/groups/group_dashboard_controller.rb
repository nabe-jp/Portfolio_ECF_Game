class Public::Groups::GroupDashboardController < Public::ApplicationController
  include Public::AuthorizeGroup
  
  # 読み込んだモジュールのメソッドをviewで使用する為に必要
  helper_method :group_moderator?

  before_action :authorize_group_member!
  
  def show
    @group_notices = @group.group_notices.active_group_notices

    if group_moderator?
      @group_events = @group.group_events.active_events_for_moderators
    else
      @group_events = @group.group_events.active_events_for_members
    end
    
    @group_posts = @group.group_posts.active_group_posts_for_members_desc
  end
end