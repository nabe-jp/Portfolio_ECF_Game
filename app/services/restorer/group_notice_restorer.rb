module Restorer
  class GroupNoticeRestorer
    def initialize(notice, restored_via_parent: false)
      @notice = notice
      @restored_via_parent = restored_via_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil, deleted_reason: nil,
          deleted_due_to_parent: false}

        if !@notice.member.member_status_active?
          raise 'お知らせの投稿を行ったメンバーが削除されているため復元出来ませんでした'
          
        # 親の連鎖削除で削除されたものを復元
        elsif @restored_via_parent && @notice.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 連鎖復元対象外(復元しない)
        elsif @restored_via_parent && !@notice.deleted_due_to_parent
          Rails.logger.info("#{self.class.name}: 
            連鎖復元対象外のグループ内お知らせの復元をスキップしました (id: #{@notice.id})")
          return

        # 個別の復元
        elsif !@restored_via_parent && !@notice.deleted_due_to_parent
          restore_params[:is_public] = false

        # 想定していないエラー
        else
          raise "#{self.class.name}で想定外のエラーが発生しました"
        end

        @notice.update!(restore_params)
      end
    end
  end
end