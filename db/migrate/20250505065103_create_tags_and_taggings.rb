class CreateTagsAndTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false
      t.timestamps
    end

    add_index :taggings, [:taggable_type, :taggable_id]
    add_index :tags, :name, unique: true
  end
end