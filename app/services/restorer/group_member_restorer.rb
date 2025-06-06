module Restorer
  class GroupMemberRestorer
    def initialize(member, restored_due_to_parent: false)
      @member = member
      @restored_due_to_parent = restored_due_to_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil,
          deleted_reason: nil, deleted_due_to_parent: false}

        # 親の連鎖削除で削除されたものを復元
        if @restored_due_to_parent && @member.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 個別の復元
        elsif !@restored_due_to_parent && !@member.deleted_due_to_parent
          restore_params[:is_public] = false

        # 想定していないアクセス
        else
          raise "#{self.class.name}で想定外のアクセスです"
        end

        @member.update!(restore_params)

        # 子要素の連鎖復元
        @member.group_events.each do |event|
          Restorer::GroupEventRestorer.new(event, restored_due_to_parent: true).call
        end

        @member.group_notices.each do |notice|
          Restorer::GroupNoticeRestorer.new(notice, restored_due_to_parent: true).call
        end

        @member.group_posts.each do |post|
          Restorer::GroupPostRestorer.new(post, restored_due_to_parent: true).call
        end
      end
    end
  end
end