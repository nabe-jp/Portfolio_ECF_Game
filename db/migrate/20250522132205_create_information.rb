class CreateInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :information do |t|
      t.string :title,       null: false
      t.text :body,        null: false
      t.datetime :published_at
      t.boolean :visible,     default: true
      t.boolean :is_pinned,      default: false
      t.datetime :deleted_at
      t.references :admin,     null: false, foreign_key: true
      t.string :audience, default: "all"                          # 対象の範囲(例：all, admin, member)
      t.integer :view_count, default: 0, null: false              # 閲覧数を記録
    

      t.timestamps
    end
  end
end
