class GroupMembership < ApplicationRecord
  include Scopes::Public::Groups
  include DeletableReason
  
  belongs_to :user
  belongs_to :group

  has_many :group_events, foreign_key: :member_id, dependent: :destroy
  has_many :group_notices, foreign_key: :member_id, dependent: :destroy
  has_many :group_posts, foreign_key: :member_id, dependent: :destroy
  has_many :group_post_comments, foreign_key: :member_id, dependent: :destroy

  # 将来的に招待機能を実装する際に使用
  # belongs_to :inviter, class_name: 'User', optional: true, foreign_key: 'invited_by_id'

 
  enum role: { member: 0, moderator: 1, owner: 2 }, _prefix: true
 
  # 将来的に承認待ち・参加中・保留中を実装する際に使用
  # enum status: { pending: 0, active: 1, suspended: 2 }

  # 重複参加防止
  validates :user_id, uniqueness: { scope: :group_id }

  validates :note, length: { maximum: 100, message: "は100文字以内で入力してください" }

  # 参加日時の自動設定
  before_create :set_joined_at

  def role_i18n
    I18n.t("activerecord.attributes.group_membership.role.#{role}")
  end

  private
  
  # もしコントローラー側で忘れても空にならないように定義
  def set_joined_at
    self.joined_at ||= Time.current
  end
end
