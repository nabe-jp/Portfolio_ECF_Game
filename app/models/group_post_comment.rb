class GroupPostComment < ApplicationRecord
  include DeletableReason
  
  belongs_to :member, class_name: "GroupMembership"
  belongs_to :group_post

  belongs_to :parent_comment, class_name: 'GroupPostComment', optional: true
  has_many :children, class_name: 'GroupPostComment', foreign_key: :parent_comment_id, dependent: :destroy

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 50, 
    message: "は1～50文字以内で入力してください" }, if: -> { body.present? }
  
  scope :active_comment, -> { where(is_public: true, hidden_on_parent_restore: false) }
end
