module Restorer
  class GroupRestorer
    def initialize(group)
      @group = group
    end

    def call
      @group.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)

      restore(@group.group_memberships)
      restore(@group.group_events)
      restore(@group.group_notices)
      restore(@group.group_posts)
      restore(@group.group_post_comments)
    end

    private

    def restore(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end