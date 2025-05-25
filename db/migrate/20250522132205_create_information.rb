class CreateInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :information do |t|
      # 基本情報
      t.string :title, null: false
      t.text :body, null: false
      
      # 公開制御
      t.boolean :is_public, default: true, null: false                  # 公開/非公開の切り替え
      t.datetime :published_at                                          # 公開日
      t.datetime :posted_at                                             # 投稿日時(新規作成時に自動/手動)

      # 閲覧・操作情報
      t.integer :view_count, default: 0, null: false                    # 閲覧数を記録
      t.references :admin, null: false, foreign_key: true               # 投稿者

      # 固定表示制御
      t.boolean :is_pinned, default: false, null: false                 # 固定表示
      t.integer :sort_order, default: 999, null: false                    # 固定表示時の手動並び順

      # 削除制御
      t.datetime :deleted_at                                            # 論理削除の時刻

      # 対象範囲
      t.string :audience, default: "all"                                # 対象の範囲(例：all, admin, member)

      t.timestamps
    end
  end
end
