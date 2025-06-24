class Group < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  NAME_MIN_LENGTH = 1
  NAME_MAX_LENGTH = 20
  DESCRIPTION_MIN_LENGTH = 1
  DESCRIPTION_MAX_LENGTH = 100

  include Scopes::Admin::Filters
  include Scopes::Public::Groups
  include Scopes::Shared::Ordering
  include DeletableReason
  
  # タグ
  acts_as_taggable_on :group_tags

  # 所有者情報(ownerに明示的にモデルを持たせる)
  belongs_to :owner, class_name: 'User'
 
  # GroupMembershipとのアソシエーション、GroupMembership側で定義しているスコープを適用したものを定義
  has_many :group_memberships, dependent: :destroy
  has_many :active_group_memberships, -> { active_members }, class_name: 'GroupMembership'
  
  # GroupMembershipをall_membersとして定義(削除されているデータも含むためadmin側にて使用)
  has_many :all_members, through: :group_memberships, source: :user

  # membersにアクティブなユーザーのみを紐づける(ユーザーとメンバー、どちらのステータスもアクティブな情報)
  has_many :active_members, -> { merge(User.active_users) }, 
    through: :active_group_memberships, source: :user

  # dashboardの管理者一覧に使用、GroupMembershipのmoderator権限を持つアクティブなユーザーをmoderatorsとして定義
  has_many :moderator_memberships, -> { where(role: :moderator).merge(GroupMembership.active_members) }, 
    class_name: 'GroupMembership'

  # moderator_membershipにアクティブなユーザーのみを紐づける(moderatorsにはアクティブなユーザーのみ紐づく)
  has_many :moderators, -> { merge(User.active_users) },through: :moderator_memberships, source: :user

  # グループが作成したもの、削除された際に関連して削除される
  has_many :group_events, dependent: :destroy
  has_many :group_notices, dependent: :destroy
  has_many :group_posts, dependent: :destroy

  # アイコン画像
  has_one_attached :group_image

  validates :name, presence: { message: "を入力してください" }
  validates :name, length: { 
    minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH,
    message: "は#{NAME_MIN_LENGTH}～#{NAME_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { name.present? }

  validates :description, presence: { message: "を入力してください" }
  validates :description, length: { 
    minimum: DESCRIPTION_MIN_LENGTH, maximum: DESCRIPTION_MAX_LENGTH,
    message: "は#{DESCRIPTION_MIN_LENGTH}～#{DESCRIPTION_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { description.present? }

  # 作成時だけslugの内容検証を行う
  validate :slug_validation, on: :create

  # 更新時にはslugが変更されていないことを検証する
  validate :slug_unchanged, on: :update

  # 投稿作成時に必ずデフォルト画像を設定(seed作成時は作動しないように設定)
  after_create :set_default_group_image, unless: :seeding?
  
  # グループ作成時、作成者もメンバーに入れる(seed作成時は作動しないように設定)
  after_create :add_owner_to_members, unless: :seeding?

  # URLをslugベースに変更するために使用
  def to_param
    slug
  end

  private

  # デフォルトの画像をアタッチ
  def set_default_group_image
    unless group_image.attached?
      default_image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_group.jpg')
      group_image.attach(io: File.open(default_image_path), filename: 'no_group.jpg', 
        content_type: 'image/jpeg')
    end
  end

  def add_owner_to_members
    group_memberships.create(user_id: owner_id, role: :owner)
  end
 
  # urlスラッグのカスタムバリデーション
  def slug_validation
    if slug.blank?
      errors.add(:slug, "を入力してください")
    elsif slug.length < 3 || slug.length > 30
      errors.add(:slug, "は3～30文字以内で入力してください")
    elsif slug !~ /\A[a-zA-Z0-9\-]+\z/
      errors.add(:slug, "は英数字とハイフン(-)のみ使用できます")
    elsif Group.exists?(slug: slug)
      errors.add(:slug, "は既に使用されています")
    end
  end

  def slug_unchanged
    if slug_changed?
      errors.add(:slug, "は作成後に変更できません")
    end
  end
end
