module Deleter
  class GroupMemberDeleter
    def self.call(member, deleted_by:, deleted_reason:)
      new(member, deleted_by: deleted_by, deleted_reason: deleted_reason).call
    end

    def initialize(member, deleted_by:, deleted_reason:)
      @member = member
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @parent_deletion_reason = :parent_group_member_deleted
    end

    def call
      now = Time.current
      # 途中で失敗したら全体ロールバック
      ActiveRecord::Base.transaction do
        @member.update!(is_deleted: true, deleted_at: now, 
          deleted_by_id: @deleted_by.id, deleted_reason: @deleted_reason)

        @member.group_events.each do |event|
          Deleter::GroupEventDeleter.call(event, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason)
        end

        @member.group_notices.each do |notice|
          Deleter::GroupNoticeDeleter.call(notice, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason)
        end

        @member.group_posts.each do |post|
          Deleter::GroupPostDeleter.call(post, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason)
        end
      end
    end
  end
end