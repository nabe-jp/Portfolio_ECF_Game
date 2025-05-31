class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      # 基本情報
      t.string :name,       null: false                                 # グループ名
      t.text :description, null: false                                  # 説明
      t.string :slug,  null: false                                      # URL用スラッグ

      # 表示・公開制御
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :is_deleted, default: false, null: false                # 論理削除
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.string :deleted_reason                                          # 削除理由
      t.boolean :deleted_due_to_parent, default: false, null: false     # 連動削除の有無
      t.boolean :hidden_on_parent_restore, default: false, null: false  # 連動削除後、親の復元に連動して非公開

      # 所有者・投稿情報
      t.integer :owner_id,  null: false                                 # 作成ユーザーID
      t.integer :user_count, default: 0, null: false                    # 所属ユーザー数
      t.integer :post_count, default: 0, null: false                    # 投稿数
      t.datetime :last_posted_at                                        # 最後に投稿された日時

      # 公開制御
      t.boolean :is_owner_visible, default: true, null: false           # グループオーナが決める公開/非公開

      t.timestamps
    end
  end
end
