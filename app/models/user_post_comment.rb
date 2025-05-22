class UserPostComment < ApplicationRecord
  belongs_to :user
  belongs_to :user_post

  scope :with_deleted, -> { all }
  scope :only_deleted, -> { where(is_deleted: true) }

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 50, 
    message: "は1～50文字以内で入力してください" }, if: -> { body.present? }
    
end
