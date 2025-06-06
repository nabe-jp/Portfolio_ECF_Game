module Deleter
  class UserPostDeleter
    # このオブジェクトの削除理由の固定
    DIRECT_PARENT_DELETION_REASON = :parent_user_deleted
    APPLIED_DELETION_REASON = :parent_user_post_deleted

    def initialize(user_post, deleted_by:, deleted_reason:, deleted_due_to_parent: false)
      @user_post = user_post
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @deleted_due_to_parent = deleted_due_to_parent
    end

    def call
      now = Time.current

      # 途中で失敗したら全体ロールバック
      ActiveRecord::Base.transaction do
        # 連鎖削除された場合
        if @deleted_due_to_parent
          return if @user_post.is_deleted

          @user_post.update!(is_deleted: true, deleted_at: now, deleted_by_id: @deleted_by.id, 
            deleted_reason: DIRECT_PARENT_DELETION_REASON, deleted_due_to_parent: true)
            restore_params[:hidden_on_parent_restore] = false
        # 個別削除の場合
        else
          @user_post.update!(is_deleted: true, deleted_at: now, deleted_by_id: @deleted_by.id, 
            deleted_reason: @deleted_reason)
        end

        # 子要素の連鎖削除
        @user_post.user_post_comments.each do |comment|
          Deleter::UserPostCommentDeleter.new(comment, deleted_by: @deleted_by, 
            deleted_reason: APPLIED_DELETION_REASON, deleted_due_to_parent: true, ).call
        end
      end
    end
  end
end