class GroupPost < ApplicationRecord
  
  acts_as_taggable_on :group_post_tags

  belongs_to :group
  belongs_to :user
  has_many :group_post_comments, dependent: :destroy

  has_one_attached :group_post_image

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }

  scope :active_group, -> { where(is_deleted: false, is_public: true, hidden_by_parent: false, is_owner_visible: true) }

  after_create :set_default_group_post_image

  private

  def set_default_group_post_image
    unless group_post_image.attached?
      group_post_image.attach( io: File.open(Rails.root.join("app/assets/images/no_group_post.png")),
        filename: "no_group_post.jpg", content_type: "image/png")
    end
  end
end