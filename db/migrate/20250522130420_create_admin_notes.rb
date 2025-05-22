class CreateAdminNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_notes do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :admin, null: false, foreign_key: true
      t.boolean :is_pinned, default: false, null: false

      t.timestamps
    end
  end
end
