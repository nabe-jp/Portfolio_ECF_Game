module Deleter
  class UserPostCommentDeleter
    def initialize(comment, deleted_by:, deleted_reason:, parent_restore: false)
      @comment = comment
      @deleted_by = deleted_by

      if parent_restore
        @deleted_reason = deleted_reason
      else
        @deleted_reason = :parent_user_post_deleted
      end

      @parent_restore = parent_restore
    end

    def call
      now = Time.current

      if @parent_restore
        return if @comment.is_deleted

        @comment.update!(is_deleted: true, deleted_at: now, deleted_by_id: @deleted_by.id,
          deleted_reason: @deleted_reason, deleted_due_to_parent: true)
      else
        @comment.update!(is_deleted: true, deleted_at: now, deleted_by_id: @deleted_by.id,
          deleted_reason: @deleted_reason)
      end

      # ※子コメントは残す。hidden_by_parent なども設定しない。
    end
  end
end