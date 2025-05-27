class Group < ApplicationRecord
  # タグ
  acts_as_taggable_on :group_tags

  # 所有者情報(ownerに明示的にモデルを持たせる)
  belongs_to :owner, class_name: 'User'
 
  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :user

  has_many :group_events, dependent: :destroy
  has_many :group_notices, dependent: :destroy
  has_many :group_posts, dependent: :destroy
  has_many :group_post_comments, dependent: :destroy
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', dependent: :destroy

  # アイコン画像
  has_one_attached :group_image

  validates :name, presence: { message: "を入力してください" }
  validates :name, length: { maximum: 20,
    message: "は1～20文字以内で入力してください" }, if: -> { name.present? }

  validates :description, presence: { message: "を入力してください" }
  validates :description, length: { maximum: 100,
    message: "は1～100文字以内で入力してください" }, if: -> { description.present? }

  validate :slug_validation

  # 公開制御
  scope :active_group, -> { where(is_deleted: false, is_public: true, hidden_by_parent: false, is_owner_visible: true) }

  # 投稿作成時に必ずデフォルト画像を設定
  after_create :set_default_group_image

  # 論理削除と連動処理
  after_update :cascade_soft_delete_associations, if: :saved_change_to_is_deleted?

  private

  # デフォルトの画像をアタッチ
  def set_default_group_image
    unless group_image.attached?
      default_image_path = Rails.root.join('app', 'assets', 'images', 'no_group.png')
      group_image.attach(io: File.open(default_image_path), 
        filename: 'no_group.png', content_type: 'image/png')
    end
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
end
