module Restorer
  class UserPostCommentRestorer
    def self.call(comment)
      now = Time.current
      comment.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end
