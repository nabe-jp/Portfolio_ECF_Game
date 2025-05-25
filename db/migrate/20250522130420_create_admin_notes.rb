class CreateAdminNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_notes do |t|
      # 本文情報
      t.string :title, null: false
      t.text :body, null: false

      # 投稿状態
      t.boolean :is_pinned, default: false, null: false                 # 固定表示

      # 投稿者
      t.references :admin, null: false, foreign_key: true               # 投稿者

      # 削除情報
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID

      t.timestamps
    end
  end
end
