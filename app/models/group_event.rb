class GroupEvent < ApplicationRecord
  belongs_to :group
  belongs_to :member, class_name: "GroupMembership"

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 30, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }

  validates :description, presence: { message: "を入力してください" }
  validates :description, length: { maximum: 100, 
    message: "は500文字以内で入力してください" }, if: -> { description.present? }

  validates :start_time, presence: { message: "を入力してください" }

  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

  # 論理削除時の処理
  scope :active_group_info, -> { where(is_deleted: false, is_public: true) }

  # 開始日時でのソート
  scope :upcoming, -> { where('start_time >= ?', Time.current).order(:start_time) }

  private
  
  # カスタムバリデーション
  def end_time_after_start_time
    if end_time < start_time
      errors.add(:end_time, "は開始日時より後にしてください")
    end
  end
end