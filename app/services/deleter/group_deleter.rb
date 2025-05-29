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
      # 投稿にぶら下がったコメントは、1対多なので配列処理(groupと直接アソシエーションが繋がっていない)
      group_post_comments = @group.group_posts.flat_map(&:group_post_comments)
      soft_delete_each(group_post_comments)
    end

    private

    def soft_delete(records)
      records.update_all(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
    end

    def soft_delete_each(records)
      Array(records).each do |record|
        record.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
      end
    end
  end
end