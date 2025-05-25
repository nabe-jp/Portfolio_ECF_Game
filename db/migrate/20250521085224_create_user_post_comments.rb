class CreateUserPostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :user_post_comments do |t|
      # 紐づけ・基本情報
      t.references :user, null: false, foreign_key: true
      t.references :user_post, null: false, foreign_key: true
      t.text :body, null: false

      # 表示制御・ステータス
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.boolean :hidden_by_parent, default: false, null: false          # 親の状態による非表示制御

      # 関連・返信情報
      t.integer :parent_comment_id                                      # コメントに対して返信をぶら下げて表示
      t.datetime :replied_at                                            # 最後に返信された日時
      
      # メタ情報
      t.integer :like_count, default: 0, null: false                    # コメントのいいね数のキャッシュ
      
      t.timestamps
    end
  end
end
