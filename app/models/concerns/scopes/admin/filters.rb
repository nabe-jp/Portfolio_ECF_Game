module Scopes::Admin::Filters
  extend ActiveSupport::Concern

  included do
    scope :inactive_users, -> {
      where.not(user_status: :active)
    }

    scope :inactive_members, -> {
      where.not(member_status: :active)
    }

    # 削除されてなく、非公開になっていないもの
    scope :active_only, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
    }

    scope :deleted_only, -> {
      where(is_deleted: true)
    }

    scope :undeleted_only, -> {
      where(is_deleted: false)
    }

    # どちらか片方でも該当すれば非公開になる
    scope :hidden_only, -> {
      where(is_public: false).or(where(hidden_on_parent_restore: true))
    }

    # 両方満たさないと公開にならない
    scope :unhidden_only, -> {
      where(is_public: true, hidden_on_parent_restore: false)
    }

    # 親コメントに使用
    scope :top_level_only, -> {
      where(parent_comment_id: nil)
    }

    # 子コメントに使用
    scope :replies_only, -> {
      where.not(parent_comment_id: nil)
    }
  end
end