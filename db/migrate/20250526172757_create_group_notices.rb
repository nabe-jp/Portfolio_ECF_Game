class CreateGroupNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :group_notices do |t|
      # 紐づけ・基本情報
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :body

      # 表示・公開制御
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID

      t.timestamps
    end
  end
end
