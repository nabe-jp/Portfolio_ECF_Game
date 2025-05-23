class CreateUserPostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :user_post_comments do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :user_post, null: false, foreign_key: true
      t.boolean :is_deleted, default: false, null: false
      t.datetime :deleted_at
      t.integer :deleted_by_id
      t.integer :parent_comment_id                                  # コメントに対して返信をぶら下げて表示
      t.integer :like_count, default: 0, null: false                # コメントに対するいいね数のキャッシュ
      t.datetime :replied_at                                        # 最後に返信された日時

      
      t.timestamps
    end
  end
end
