module Restorer
  class GroupPostRestorer
    def initialize(group_post)
      @group_post = group_post
    end

    def call
      @group_post.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
      restore(@group_post.group_post_comments)
    end

    private

    def restore(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil, is_public: false)
    end
  end
end