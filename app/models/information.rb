class Information < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  TITLE_MIN_LENGTH = 1
  TITLE_MAX_LENGTH = 20
  BODY_MIN_LENGTH = 1
  BODY_MAX_LENGTH = 200

  include Scopes::Admin::Filters
  include Scopes::Public::Homes
  include Scopes::Shared::Ordering
  
  belongs_to :admin

  attr_accessor :enable_sort_order
  
  before_validation :set_default_sort_order

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
