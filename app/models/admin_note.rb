class AdminNote < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  TITLE_MIN_LENGTH = 1
  TITLE_MAX_LENGTH = 20
  BODY_MIN_LENGTH = 1
  BODY_MAX_LENGTH = 200

  include Scopes::Admin::Filters
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :admin

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
    
end
