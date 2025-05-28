class CreateGroupPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :group_posts do |t|
      # 紐づけ・基本情報
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body

      # 表示・公開制御
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.boolean :hidden_by_parent, default: false, null: false          # 親ユーザーが非表示のとき制御用

      # 表示状態関連
      t.boolean :is_pinned, default: false, null: false                 # 固定表示
      t.integer :sort_order, default: 999, null: false                  # 固定表示時の手動並び順
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
