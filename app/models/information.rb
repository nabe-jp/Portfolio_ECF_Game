class Information < ApplicationRecord
  include Scopes::Public::Homes
  belongs_to :admin

  attr_accessor :enable_sort_order
  
  before_validation :set_default_sort_order

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }

  validates :sort_order, presence: true, if: -> { ActiveModel::Type::Boolean.new.cast(enable_sort_order) }

  private

  # 表示順が指定されなければデフォルト値を入れる
  def set_default_sort_order
    unless ActiveModel::Type::Boolean.new.cast(enable_sort_order)
      # チェックなし → 自動で999(並び順制御しない扱い)
      self.sort_order = 999 if sort_order.nil?
    end
  end
end
