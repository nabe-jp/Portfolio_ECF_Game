class CreateGroupMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :group_memberships do |t|
      # 所属情報
      t.references :group, null: false, foreign_key: true               # 所属グループ
      t.references :user,  null: false, foreign_key: true               # 所属ユーザー
      t.datetime :joined_at                                             # 参加日時
      t.integer :invited_by_id                                          # 招待したユーザーID
      t.text :note                                                      # 管理者メモ

      # 削除関連
      t.integer :member_status, default: 0, null: false                 # メンバーのステータス
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.integer :deleted_reason                                         # 削除理由(enumで管理)
      t.boolean :deleted_due_to_parent, default: false, null: false     # 連動削除の有無

      # 承認関連
      t.integer :approved_by_id                                         # 承認したユーザーID
      t.datetime :approved_at                                           # 承認日時

      # 公開制御関連
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :hidden_on_parent_restore, default: false, null: false  # 連動削除後、親の復元に連動して非公開

       # 権限
      t.integer :role, default: 0, null: false                          # 権限(enumで管理)

      t.timestamps
    end

    # 重複参加防止(バリデーションだけでなく、DBレベルでも安全性を保証するために記載)
    add_index :group_memberships, [:user_id, :group_id], unique: true
  end
end
