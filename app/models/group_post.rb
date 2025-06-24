class GroupPost < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  TITLE_MIN_LENGTH = 1
  TITLE_MAX_LENGTH = 20
  BODY_MIN_LENGTH = 1
  BODY_MAX_LENGTH = 200

  include Scopes::Admin::Filters
  include Scopes::Public::Groups
  include Scopes::Shared::Ordering
  include DeletableReason
  
  acts_as_taggable_on :group_post_tags

  belongs_to :group
  belongs_to :member, class_name: "GroupMembership"
  has_many :group_post_comments, dependent: :destroy

  has_one_attached :group_post_image

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { 
    minimum: TITLE_MIN_LENGTH, maximum: TITLE_MAX_LENGTH,
    message: "は#{TITLE_MIN_LENGTH}～#{TITLE_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { title.present? }

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { 
    minimum: BODY_MIN_LENGTH, maximum: BODY_MAX_LENGTH,
    message: "は#{BODY_MIN_LENGTH}～#{BODY_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { body.present? }

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