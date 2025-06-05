class GroupNotice < ApplicationRecord
  belongs_to :group
  belongs_to :member, class_name: "GroupMembership"

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }  

  scope :active_group_info, -> { where(is_deleted: false, is_public: true).order(created_at: :desc) }
end
