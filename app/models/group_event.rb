class GroupEvent < ApplicationRecord
  include Scopes::Admin::Filters
  include Scopes::Public::Groups
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :group
  belongs_to :member, class_name: "GroupMembership"

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }

  validates :description, presence: { message: "を入力してください" }
  validates :description, length: { maximum: 100, 
    message: "は100文字以内で入力してください" }, if: -> { description.present? }

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