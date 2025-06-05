module Deleter
  class GroupMemberDeleter
    def self.call(member, deleted_by:, deleted_reason:)
      new(member, deleted_by: deleted_by, deleted_reason: deleted_reason).call
    end

    def initialize(member, deleted_by:, deleted_reason:)
      @member = member
      @deleted_by = deleted_by
      @now = Time.current
      @deleted_reason = deleted_reason
    end

    def call
      @member.update!(is_deleted: true, deleted_at: @now, 
        deleted_by_id: @deleted_by.id, deleted_reason: @deleted_reason)

      soft_delete(@member.group_events)
      soft_delete(@member.group_notices)
      soft_delete(@member.group_posts)

      group_post_comments = @member.group_posts.flat_map(&:group_post_comments)
      soft_delete_each(group_post_comments)
    end

    private

    def soft_delete(records)
      records.update_all(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
    end

    def soft_delete_each(records)
      Array(records).each do |record|
        record.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
      end
    end
  end
end