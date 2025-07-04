class CreateGroupPostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :group_post_comments do |t|
      # 紐づけ・基本情報
      t.references :group_post, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: { to_table: :group_memberships }
      t.text :body

      # 削除関連
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.integer :deleted_reason                                         # 削除理由(enumで管理)
      t.boolean :deleted_due_to_parent, default: false, null: false     # 連動削除の有無

      # 公開制御関連
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      # 削除されていると表示するため現在未使用だが設計を変更する可能性があるため記載
      t.boolean :hidden_on_parent_restore, default: false, null: false  # 連動削除後、親の復元に連動して非公開

      # 返信情報
      t.integer :parent_comment_id                                      # コメントに対して返信をぶら下げて表示
      t.datetime :replied_at                                            # 最後に返信された日時
      
      # メタ情報
      t.integer :like_count, default: 0, null: false                    # コメントのいいね数のキャッシュ
      
      t.timestamps
    end
  end
end
