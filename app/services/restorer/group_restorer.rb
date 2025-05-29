module Restorer
  class GroupRestorer
    def initialize(group)
      @group = group
    end

    def call
      @group.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)

      restore_without_is_public(@group.group_memberships)
      restore(@group.group_events)
      restore(@group.group_notices)
      restore(@group.group_posts)
      # 投稿にぶら下がったコメントは、1対多なので配列処理(groupと直接アソシエーションが繋がっていない)
      group_post_comments = @group.group_posts.flat_map(&:group_post_comments)
      restore_each(group_post_comments)
    end

    private

    def restore(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil, is_public: false)
    end

    def restore_each(records)
      Array(records).each do |record|
        record.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil, is_public: false)
      end
    end
    
    def restore_without_is_public(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end