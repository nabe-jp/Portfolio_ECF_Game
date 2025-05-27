class CreateGroupMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :group_memberships do |t|
      # 所属情報
      t.references :group, null: false, foreign_key: true               # 所属グループ
      t.references :user,  null: false, foreign_key: true               # 所属ユーザー
      t.datetime :joined_at                                             # 参加日時
      t.integer :invited_by_id                                          # 招待したユーザーID
      t.text :note                                                      # 管理者メモ

       # 権限・状態
      t.integer :role, default: 0, null: false                          # 権限(enum: 一般, モデレーター, 管理者など)
      t.integer :status, default: 0, null: false                        # 状態(enum: pending, active, suspended など)

      # 削除制御
      t.boolean :is_deleted, default: false, null: false                # 論理削除
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID

      t.timestamps
    end

    # 重複参加防止(バリデーションだけでなく、DBレベルでも安全性を保証するために記載)
    add_index :group_memberships, [:user_id, :group_id], unique: true
  end
end
