module Deleter
  class GroupDeleter
    def initialize(group, deleted_by:)
      @group = group
      @deleted_by = deleted_by
      @now = Time.current
    end

    def call
      @group.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)

      soft_delete(@group.group_memberships)
      soft_delete(@group.group_events)
      soft_delete(@group.group_notices)
      soft_delete(@group.group_posts)
      soft_delete(@group.group_post_comments)
    end

    private

    def soft_delete(records)
      records.update_all(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
    end
  end
end