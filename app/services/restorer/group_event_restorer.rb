module Restorer
  class GroupEventRestorer
    def self.call(event)
      now = Time.current
      event.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end