class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      # 基本情報
      t.string :name,       null: false                                 # グループ名
      t.text :description, null: false                                  # 説明
      t.string :slug,  null: false                                      # URL用スラッグ

      # 所有者・投稿情報
      t.integer :owner_id,  null: false                                 # 作成ユーザーID
      t.integer :user_count, default: 0, null: false                    # 所属ユーザー数
      t.integer :post_count, default: 0, null: false                    # 投稿数
      t.datetime :last_posted_at                                        # 最後に投稿された日時

      # 公開制御
      t.boolean :is_owner_visible, default: true, null: false           # グループオーナが決める公開/非公開

      # 表示制御・ステータス
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :hidden_by_parent, default: false, null: false          # 関連元により非表示

      t.timestamps
    end
  end
end
