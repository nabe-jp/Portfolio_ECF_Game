module DeletableReason
  extend ActiveSupport::Concern

  included do
    enum deleted_reason: {
      # 0〜99: ユーザー都合
      self_deleted: 0,                            # 自身で削除(例: アカウント削除)
      voluntarily_left_group: 1,                  # グループから自発的に退会
      removed_by_group_authority: 2,              # グループ管理権限者(オーナーまたはマネージャー)により削除

      # 100〜199: 管理者都合
      removed_by_admin: 100,                      # サイト管理者による削除

      # 1000〜1999: 削除伝播(親リソースの削除により削除)
      parent_user_deleted: 1000,                  # ユーザーが削除されたことによる削除
      parent_user_post_deleted: 1001,             # ユーザーの投稿が削除されたことによる削除
      parent_user_post_comment_deleted: 1002,     # 投稿コメントの削除に伴う削除
      parent_group_deleted: 1003,                 # グループ自体の削除による削除
      parent_group_member_deleted: 1004,          # メンバーが削除されたことで関連データが削除
      parent_group_post_deleted: 1005,            # グループ投稿が削除されたことで削除
      parent_group_post_comment_deleted: 1006     # グループ投稿のコメントが削除されたことで削除
    }, _prefix: true                              # 例: deleted_reason_self_deleted? のように明示的に呼べる
  end
end
