class AdminNote < ApplicationRecord
  include Scopes::Admin::Filters
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :admin

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }  
    
end
