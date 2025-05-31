module Deleter
  class GroupEventDeleter
    def self.call(event, deleted_by:)
      now = Time.current
      event.update!(is_deleted: true, deleted_at: now, deleted_by_id: deleted_by.id)
    end
  end
end