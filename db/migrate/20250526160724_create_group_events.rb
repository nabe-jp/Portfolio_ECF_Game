class CreateGroupEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :group_events do |t|
      # 紐づけ・基本情報
      t.references :group, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: { to_table: :group_memberships }
      t.string :title, null: false
      t.text :description

      # 削除関連
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID
      t.integer :deleted_reason                                         # 削除理由(enumで管理)
      t.boolean :deleted_due_to_parent, default: false, null: false     # 連動削除の有無

      # 公開制御関連
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :hidden_on_parent_restore, default: false, null: false  # 連動削除後、親の復元に連動して非公開

      # 固定表示制御
      t.boolean :is_pinned, default: false, null: false                 # 固定表示
      t.integer :sort_order, default: 999, null: false                  # 固定表示時の手動並び順
      
      # 日時の表示
      t.datetime :start_time, null: false                               # 開始日時
      t.datetime :end_time                                              # 終了日時

      t.timestamps
    end
  end
end
