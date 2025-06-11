module Deleter
  class UserPostCommentDeleter
    # このオブジェクトの削除理由の固定
    DIRECT_PARENT_DELETION_REASON = :parent_user_post_deleted
    APPLIED_DELETION_REASON = :parent_user_post_comment_deleted

    def initialize(comment, deleted_by:, deleted_reason:, deleted_via_parent: false)
      @comment = comment
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @deleted_via_parent = deleted_via_parent
    end

    def call
      # 途中で失敗したら全体をロールバック
      ActiveRecord::Base.transaction do
        now = Time.current
        
        delete_params = {is_deleted: true, deleted_at: now, deleted_by_id: @deleted_by.id,
          deleted_due_to_parent: false, hidden_on_parent_restore: false}

        # 連鎖削除の場合
        if @deleted_via_parent
          return if @comment.is_deleted

          delete_params[:deleted_reason] = DIRECT_PARENT_DELETION_REASON
          delete_params[:deleted_due_to_parent] = true

        # 個別削除の場合
        else
          delete_params[:deleted_reason] = @deleted_reason
        end

        @comment.update!(delete_params)
      end

      # ※子コメントは残す。hidden_by_parentなども設定しない。
    end
  end
end