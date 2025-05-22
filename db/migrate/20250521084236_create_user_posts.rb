class CreateUserPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :user_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.boolean :is_deleted, default: false, null: false
      t.datetime :deleted_at
      t.integer  :deleted_by_id

      t.timestamps
    end
  end
end
