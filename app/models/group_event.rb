class GroupEvent < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  TITLE_MIN_LENGTH = 1
  TITLE_MAX_LENGTH = 20
  DESCRIPTION_MIN_LENGTH = 1
  DESCRIPTION_MAX_LENGTH = 100

  include Scopes::Admin::Filters
  include Scopes::Public::Groups
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :group
  belongs_to :member, class_name: "GroupMembership"

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { 
    minimum: TITLE_MIN_LENGTH, maximum: TITLE_MAX_LENGTH,
    message: "は#{TITLE_MIN_LENGTH}～#{TITLE_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { title.present? }

  validates :description, presence: { message: "を入力してください" }
  validates :description, length: { 
    minimum: DESCRIPTION_MIN_LENGTH, maximum: DESCRIPTION_MAX_LENGTH,
    message: "は#{DESCRIPTION_MIN_LENGTH}～#{DESCRIPTION_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { description.present? }

  validates :start_time, presence: { message: "を入力してください" }

  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

  private
  
  # カスタムバリデーション
  def end_time_after_start_time
    if end_time < start_time
      errors.add(:end_time, "は開始日時より後にしてください")
    end
  end
end