module Deleter
  class GroupPostCommentDeleter
    def self.call(comment, deleted_by:)
      now = Time.current

      # 親コメントを論理削除
      comment.update!(is_deleted: true, deleted_at: now, deleted_by_id: deleted_by.id)

      # 子コメントは残すので変更しない
    end
  end
end