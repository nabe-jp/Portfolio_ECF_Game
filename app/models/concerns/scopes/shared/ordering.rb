# 並べ替え関連のスコープ
module Scopes::Shared::Ordering
  extend ActiveSupport::Concern

  included do
    # 並べ替えに使用するのでpinnedはこちらに記載
    scope :pinned, -> { where(is_pinned: true) }

    scope :unpinned, -> { where.not(is_pinned: true) }

    scope :created_asc, -> { order(created_at: :asc) }

    scope :created_desc, -> { order(created_at: :desc) }

    scope :published_asc, -> { order(published_at: :asc) }

    scope :published_desc, -> { order(published_at: :desc) }
  end
end