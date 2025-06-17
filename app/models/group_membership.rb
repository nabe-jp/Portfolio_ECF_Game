class GroupMembership < ApplicationRecord
  include Scopes::Admin::Filters
  include Scopes::Public::Groups
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :user
  belongs_to :group

  # メンバーが作成したもの、削除された際に関連して削除される
  has_many :group_events, foreign_key: :member_id, dependent: :destroy
  has_many :group_notices, foreign_key: :member_id, dependent: :destroy
  has_many :group_posts, foreign_key: :member_id, dependent: :destroy
  has_many :group_post_comments, foreign_key: :member_id, dependent: :destroy

  # 将来的に招待機能を実装する際に使用
  # belongs_to :inviter, class_name: 'User', optional: true, foreign_key: 'invited_by_id'

  # 参加中・承認待ち・承認拒否・非アクティブ(自主退会・連鎖削除)・グループ管理者空のキック・サイト運営による制限
  enum member_status: { active: 0, pending: 1, rejected: 2, inactive: 3, kicked: 4, suspended: 5 }, 
    _prefix: true

  # _prefix: trueを使い.role_～という形で使えるようにし、名前の衝突を避ける
  enum role: { member: 0, moderator: 1, owner: 2 }, _prefix: true

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
