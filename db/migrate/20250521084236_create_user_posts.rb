class CreateUserPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :user_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.boolean :is_deleted, default: false, null: false
      t.datetime :deleted_at
      t.integer :deleted_by_id
      t.integer :like_count, default: 0, null: false                # いいね数をキャッシュ
      t.datetime :last_commented_at                                 # 最後にコメントされた日時
      t.boolean :is_public, default: true, null: false              # 公開/非公開の切り替え
    
      t.timestamps
    end
  end
end
