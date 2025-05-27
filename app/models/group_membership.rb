class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # 将来的に招待機能を実装する際に使用
  # belongs_to :inviter, class_name: 'User', optional: true, foreign_key: 'invited_by_id'

  # 将来的に管理機能を実装する際に使用
  # enum role: { general: 0, moderator: 1, admin: 2 }

  # 将来的に承認待ち・参加中・保留中を実装する際に使用
  # enum status: { pending: 0, active: 1, suspended: 2 }

  # 重複参加防止
  validates :user_id, uniqueness: { scope: :group_id }

  # 参加日時の自動設定
  before_create :set_joined_at

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
