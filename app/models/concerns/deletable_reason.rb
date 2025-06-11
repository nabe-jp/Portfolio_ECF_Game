module DeletableReason
  extend ActiveSupport::Concern

  included do
    enum deleted_reason: {
      # 0〜99: ユーザー都合
      self_deleted: 0,                            # 自身で削除(例: アカウント削除)
      post_user: 1,                               # 投稿を作成したユーザーによる削除
      voluntarily_left_group: 2,                  # グループから自発的に退会

      # 100〜199: グループ管理者都合
      removed_by_group_authority: 100,            # グループ管理権限者(オーナーまたはマネージャー)による削除
      kicked_by_group_moderator: 101,             # グループ管理者による強制退会
      group_disbanded: 102,                       # グループ削除による強制退会

      # 200〜299: サイト管理者都合
      removed_by_admin: 200,                      # サイト管理者による削除

      # 1000〜1999: 削除伝播(親リソースの削除により削除)
      parent_user_deleted: 1000,                  # ユーザーが削除されたことによる削除
      parent_user_post_deleted: 1001,             # ユーザーの投稿が削除されたことによる削除
      parent_user_post_comment_deleted: 1002,     # 投稿コメントが削除されたことによる削除
      parent_group_deleted: 1003,                 # グループ自体が削除されたことによる削除
      parent_group_member_deleted: 1004,          # メンバーが削除されたことによる削除
      parent_group_event_deleted: 1005,           # グループ内イベントが削除されたことによる削除
      parent_group_notice_deleted: 1006,          # グループ内お知らせが削除されたことによる削除
      parent_group_post_deleted: 1007,            # グループ投稿が削除されたことによる削除
      parent_group_post_comment_deleted: 1008     # グループ投稿のコメントが削除されたことによる削除
    }, _prefix: true                              # 例: deleted_reason_self_deleted? のように明示的に呼べる
  end
end
