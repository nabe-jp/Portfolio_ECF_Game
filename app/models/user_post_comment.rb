class UserPostComment < ApplicationRecord
  include DeletableReason
  
  belongs_to :user
  belongs_to :user_post

  # 親コメント(返信先)との関連
  belongs_to :parent_comment, class_name: "UserPostComment", optional: true
  has_many :replies, class_name: "UserPostComment", foreign_key: :parent_comment_id, dependent: :destroy

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 50, 
    message: "は1～50文字以内で入力してください" }, if: -> { body.present? }

  scope :active, -> { where(is_deleted: false, is_public: true, hidden_on_parent_restore: false) }
end