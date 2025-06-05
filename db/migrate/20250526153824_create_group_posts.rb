class CreateGroupPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :group_posts do |t|
      # 紐づけ・基本情報
      t.references :group, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: { to_table: :group_memberships }
      t.string :title, null: false
      t.text :body

      # 表示・公開制御
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.string :deleted_reason                                          # 削除理由
      t.boolean :deleted_due_to_parent, default: false, null: false     # 連動削除の有無
      t.boolean :hidden_on_parent_restore, default: false, null: false  # 連動削除後、親の復元に連動して非公開

      # 表示状態関連
      t.boolean :visible_to_non_members, default: false, null: false    # メンバー以外への投稿の公開制限

      # 統計・時系列
      t.integer :like_count, default: 0, null: false                    # いいね数をキャッシュ
      t.datetime :posted_at                                             # 投稿日時(表示順用)
      t.datetime :published_at                                          # 公開日時(表示順用)
      t.datetime :last_commented_at                                     # 最後にコメントされた日時

      t.timestamps
    end
  end
end
