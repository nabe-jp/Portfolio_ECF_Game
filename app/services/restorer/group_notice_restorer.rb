module Restorer
  class GroupNoticeRestorer
    def self.call(notice)
      now = Time.current
      notice.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end