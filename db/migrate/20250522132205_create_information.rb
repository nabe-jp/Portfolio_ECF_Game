class CreateInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :information do |t|
      # 基本情報
      t.string :title, null: false
      t.text :body, null: false
      
      # 削除関連
      t.boolean :is_deleted, default: false, null: false                # 論理削除フラグ
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除したユーザーID

      # 公開制御関連
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.datetime :published_at                                          # 公開日
      
      # 表示状態関連(ピン留め・並び順)
      t.boolean :is_pinned, default: false, null: false                 # 固定表示
      t.integer :sort_order, default: 999, null: false                  # 固定表示時の手動並び順
      
      # 閲覧・操作情報
      t.references :admin, null: false, foreign_key: true               # 投稿者

      # 対象範囲
      t.string :audience, default: "all"                                # 対象の範囲(例：all, admin, member)

      t.timestamps
    end
  end
end
