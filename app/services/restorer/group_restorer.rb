module Restorer
  class GroupRestorer
    def initialize(group, restored_via_parent: false)
      @group = group
      @restored_via_parent = restored_via_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil,
          deleted_reason: nil, deleted_due_to_parent: false}

        if !@group.owner.user_status_active?
          raise 'グループオーナーが削除されているため復元出来ませんでした'
    
        # 親の連鎖削除で削除されたものを復元
        elsif @restored_via_parent && @group.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 連鎖復元対象外(復元しない)
        elsif @restored_via_parent && !@group.deleted_due_to_parent
          Rails.logger.info("#{self.class.name}: 
            連鎖復元対象外のグループの復元をスキップしました (id: #{@group.id})")
          return

        # 個別の復元
        elsif !@restored_via_parent && !@group.deleted_due_to_parent
          restore_params[:is_public] = false

        # 想定していないエラー
        else
          raise "#{self.class.name}で想定外のエラーが発生しました"
        end

        @group.update!(restore_params)

        # 子要素の連鎖復元
        @group.group_memberships.each do |membership|
          Restorer::GroupMemberRestorer.new(membership, restored_via_parent: true).call
        end
      end
    end
  end
end