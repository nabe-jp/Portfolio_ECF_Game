class Information < ApplicationRecord
  belongs_to :admin

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
end
