module Deleter
  class UserPostCommentDeleter
    def self.call(comment, deleted_by:)
      now = Time.current

      comment.update!(is_deleted: true, deleted_at: now, deleted_by_id: deleted_by.id)

      # ※子コメントは残す。hidden_by_parent なども設定しない。
    end
  end
end