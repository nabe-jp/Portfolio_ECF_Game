# public側のホームにて使用するスコープ、見てわかりやすいようにまた一貫性の重視によりやや冗長
module Scopes::Public::Homes
  extend ActiveSupport::Concern

  included do
    # お知らせに使用
    scope :active_information_pinned, -> {
      where(is_deleted: false, is_public: true, is_pinned: true)
        .order(sort_order: :asc, published_at: :desc)
    }

    scope :active_information_not_pinned, -> {
      where(is_deleted: false, is_public: true, is_pinned: false)
        .order(published_at: :desc)
    }
  end
end