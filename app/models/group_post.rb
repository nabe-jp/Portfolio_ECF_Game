class GroupPost < ApplicationRecord
  include DeletableReason
  
  acts_as_taggable_on :group_post_tags

  belongs_to :group
  belongs_to :member, class_name: "GroupMembership"
  has_many :group_post_comments, dependent: :destroy

  has_one_attached :group_post_image

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }

  scope :active_group, -> { 
    where(is_deleted: false, is_public: true, hidden_on_parent_restore: false, is_owner_visible: true) }
  scope :public_visible_to_non_members, -> { 
    where(visible_to_non_members: true, is_deleted: false, is_public: true, hidden_on_parent_restore: false)
      .order(created_at: :desc) }

  # 投稿作成時に必ずデフォルト画像を設定(seed作成時は作動しないように設定)
  after_create :set_default_group_post_image, unless: :seeding?

  private

  def set_default_group_post_image
    unless group_post_image.attached?
      default_image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_group_post.jpg')
      group_post_image.attach(io: File.open(default_image_path), filename: 'no_group_post.jpg', 
          content_type: 'image/jpeg')
      end
  end
end