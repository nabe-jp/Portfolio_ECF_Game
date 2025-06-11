module Deleter
  class GroupDeleter
    # このオブジェクトの削除理由の固定
    DIRECT_PARENT_DELETION_REASON = :parent_user_deleted
    APPLIED_DELETION_REASON = :parent_group_deleted_applied

    def initialize(group, deleted_by:, deleted_reason:, deleted_via_parent: false)
      @group = group
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

        if @deleted_via_parent
          return if @group.is_deleted

          delete_params[:deleted_reason] = DIRECT_PARENT_DELETION_REASON
          delete_params[:deleted_due_to_parent] = true
        else
          delete_params[:deleted_reason] = @deleted_reason
        end

        @group.update!(delete_params)

        # 子要素の連鎖削除
        @group.group_memberships.each do |member|
          Deleter::GroupMemberDeleter.new(member, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end
      end
    end
  end
end