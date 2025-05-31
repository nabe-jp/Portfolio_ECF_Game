module Deleter
  class GroupNoticeDeleter
    def self.call(notice, deleted_by:)
      now = Time.current
      notice.update!(is_deleted: true, deleted_at: now, deleted_by_id: deleted_by.id)
    end
  end
end