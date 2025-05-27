module Deleter
  class GroupPostSoftDeleter
    def initialize(group_post, deleted_by:)
      @group_post = group_post
      @deleted_by = deleted_by
      @now = Time.current
    end

    def call
      @group_post.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
      soft_delete(@group_post.group_post_comments)
    end

    private

    def soft_delete(records)
      records.update_all(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
    end
  end
end