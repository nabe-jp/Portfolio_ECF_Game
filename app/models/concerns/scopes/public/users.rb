# public側のユーザー関連にて使用するスコープ、見てわかりやすいようにまた一貫性の重視によりコメント以外やや冗長
module Scopes::Public::Users
  extend ActiveSupport::Concern

  included do
    # ユーザーに使用
    scope :active_users, -> {
      where(user_status: :active)
    }

    scope :active_users_asc, -> {
      where(user_status: :active)
        .order(created_at: :asc)
    }

    scope :active_users_desc, -> {
      where(user_status: :active)
        .order(created_at: :desc)
    }

    # 投稿に使用
    scope :active_posts_asc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :asc)
    }

    scope :active_posts_desc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :desc)
    }

    # 親コメントに使用(コメントは削除されたコメントは削除されていると表示する)
    scope :visible_top_level, -> {
      where(parent_comment_id: nil, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :desc)
    }

    # 子コメントに使用
    scope :visible_replies, -> {
      where.not(parent_comment_id: nil).where(is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :asc)
    }
  end
end