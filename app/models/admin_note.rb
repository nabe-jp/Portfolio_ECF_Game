class AdminNote < ApplicationRecord
  include DeletableReason
  
  belongs_to :admin

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }  
    
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
end
