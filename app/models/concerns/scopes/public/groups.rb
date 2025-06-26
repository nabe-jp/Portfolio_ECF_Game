# public側のグループ関連にて使用するスコープ、見てわかりやすいようにまた一貫性の重視によりコメント以外やや冗長
module Scopes::Public::Groups
  extend ActiveSupport::Concern

  included do
    # グループに使用
    scope :active_groups_asc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :asc)
    }
    
    scope :active_groups_desc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :desc)
    }

    # メンバーに使用
    scope :active_members, -> {
      where(member_status: :active, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :asc)
    }

    scope :pending_members, -> { where(member_status: 'pending') }
    
    # グループ内のお知らせに使用
    scope :active_group_notices, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(is_pinned: :desc, sort_order: :asc, created_at: :desc)
    }

    # グループ内のイベントに使用
    scope :active_events_for_moderators, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(:start_time) 
    }

    scope :active_events_for_members, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .where('end_time >= ?', Time.current)
          .order(:start_time) 
    }
    
    # グループ内投稿、グループ内での表示に使用(単体・複数昇順・複数降順)
    scope :active_group_post_for_members, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
    }

    scope :active_group_posts_for_members_asc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :asc)
    }
    
    scope :active_group_posts_for_members_desc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :desc)
    }

    # グループ内投稿、グループ外(グループメンバー以外が投稿を見れる箇所)での表示に使用(単体・複数昇順・複数降順)
    scope :active_group_post_for_all, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false, 
        visible_to_non_members: true)
    }

    scope :active_group_posts_for_all_asc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false, 
        visible_to_non_members: true)
          .order(created_at: :asc)
    }
    
    scope :active_group_posts_for_all_desc, -> {
      where(is_deleted: false, is_public: true, hidden_on_parent_restore: false, 
        visible_to_non_members: true)
          .order(created_at: :desc)
    }

    # コメントに使用、コメントはview内で削除されていると表示するので削除の有無を問わない(単体・親・子)
    scope :active_group_post_comment, -> {
      where(is_public: true, hidden_on_parent_restore: false)
    }

    scope :visible_top_level, -> {
      where(parent_comment_id: nil, is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :desc)
    }

    scope :visible_replies, -> {
      where.not(parent_comment_id: nil).where(is_public: true, hidden_on_parent_restore: false)
        .order(created_at: :asc)
    }
  end
end