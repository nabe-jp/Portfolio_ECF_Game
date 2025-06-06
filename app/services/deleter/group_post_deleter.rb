module Deleter
  class GroupPostDeleter
    def self.call(group_post, deleted_by:, deleted_reason:)
      new(group_post, deleted_by: deleted_by, deleted_reason: deleted_reason).call
    end

    def initialize(group_post, deleted_by:, deleted_reason:)
      @group_post = group_post
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @parent_deletion_reason = :parent_group_post_deleted
    end

    def call
      now = Time.current
      # 途中で失敗したら全体ロールバック
      ActiveRecord::Base.transaction do
        @group_post.update!(is_deleted: true, deleted_at: now, 
          deleted_by_id: @deleted_by.id, deleted_reason: @deleted_reason)

        @group_post.group_post_comments.each do |comment|
          Deleter::GroupPostCommentDeleter.call(comment, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason)
        end
      end
    end
  end
end