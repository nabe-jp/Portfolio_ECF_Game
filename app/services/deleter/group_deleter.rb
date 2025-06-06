module Deleter
  class GroupDeleter
    def self.call(group, deleted_by:, deleted_reason:)
      new(group, deleted_by: deleted_by, deleted_reason: deleted_reason).call
    end

    def initialize(group, deleted_by:, deleted_reason:)
      @group = group
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @parent_deletion_reason = :parent_group_deleted
    end

    def call
      now = Time.current
      # 途中で失敗したら全体ロールバック
      ActiveRecord::Base.transaction do
        @group.update!(is_deleted: true, deleted_at: now, 
          deleted_by_id: @deleted_by.id, deleted_reason: @deleted_reason)
    
        @group.group_memberships.each do |member|
          Deleter::GroupMemberDeleter.call(member, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason)
        end
      end
    end
  end
end