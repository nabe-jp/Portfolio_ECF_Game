module Deleter
  class GroupMemberDeleter
    # このオブジェクトの削除理由の固定
    DIRECT_PARENT_DELETION_REASON = :parent_group_deleted
    APPLIED_DELETION_REASON = :parent_group_member_deleted

    def initialize(member, deleted_by:, deleted_reason:, deleted_via_parent: false)
      @member = member
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @deleted_via_parent = deleted_via_parent
    end

    def call
      # 途中で失敗したら全体をロールバック
      ActiveRecord::Base.transaction do
        now = Time.current
        
        delete_params = {deleted_at: now, deleted_by_id: @deleted_by.id,
          deleted_due_to_parent: false, hidden_on_parent_restore: false}

        # 連鎖削除の場合
        if @deleted_via_parent
          return if !@member.member_status_active? 

          delete_params[:member_status] = :inactive
          delete_params[:deleted_reason] = DIRECT_PARENT_DELETION_REASON
          delete_params[:deleted_due_to_parent] = true

        # 個別削除の場合
        else
          delete_params[:deleted_reason] = @deleted_reason

          if @deleted_reason == :removed_by_admin
            delete_params[:member_status] = :suspended
          elsif @deleted_reason == :kicked_by_group_moderator
            delete_params[:member_status] = :kicked
          else
            raise "#{self.class.name}でmember_statusの設定でエラーが発生しました"
          end
        end

        @member.update!(delete_params)

        # 子要素の連鎖削除
        @member.group_events.each do |event|
          Deleter::GroupEventDeleter.new(event, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        @member.group_notices.each do |notice|
          Deleter::GroupNoticeDeleter.new(notice, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        @member.group_posts.each do |post|
          Deleter::GroupPostDeleter.new(post, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        @member.group_post_comments.each do |comment|
          Deleter::GroupPostCommentDeleter.new(comment, deleted_by: @deleted_by, 
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end
      end
    end
  end
end