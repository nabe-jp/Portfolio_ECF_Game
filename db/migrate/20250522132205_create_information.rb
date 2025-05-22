class CreateInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :information do |t|
      t.string   :title,       null: false
      t.text     :body,        null: false
      t.datetime :published_at
      t.boolean  :visible,     default: true
      t.boolean  :pinned,      default: false
      t.datetime :deleted_at
      t.references :admin,     null: false, foreign_key: true

      t.timestamps
    end
  end
end
