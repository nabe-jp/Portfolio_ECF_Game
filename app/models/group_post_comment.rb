class GroupPostComment < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :group_post

  belongs_to :parent_comment, class_name: 'GroupPostComment', optional: true
  has_many :children, class_name: 'GroupPostComment', foreign_key: :parent_comment_id, dependent: :destroy

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 50, 
    message: "は1～50文字以内で入力してください" }, if: -> { body.present? }
  
  scope :active_group, -> { where(is_deleted: false, is_public: true, hidden_by_parent: false, is_owner_visible: true) }
end
