# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_06_01_063131) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.boolean "is_pinned", default: false, null: false
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_admin_notes_on_admin_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "group_events", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "member_id", null: false
    t.string "title", null: false
    t.text "description"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.boolean "is_pinned", default: false, null: false
    t.integer "sort_order", default: 999, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_events_on_group_id"
    t.index ["member_id"], name: "index_group_events_on_member_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.datetime "joined_at"
    t.integer "invited_by_id"
    t.text "note"
    t.integer "member_status", default: 0, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.integer "approved_by_id"
    t.datetime "approved_at"
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "group_notices", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "member_id", null: false
    t.string "title"
    t.text "body"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.boolean "is_pinned", default: false, null: false
    t.integer "sort_order", default: 999, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_notices_on_group_id"
    t.index ["member_id"], name: "index_group_notices_on_member_id"
  end

  create_table "group_post_comments", force: :cascade do |t|
    t.integer "group_post_id", null: false
    t.integer "member_id", null: false
    t.text "body"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.integer "parent_comment_id"
    t.datetime "replied_at"
    t.integer "like_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_post_id"], name: "index_group_post_comments_on_group_post_id"
    t.index ["member_id"], name: "index_group_post_comments_on_member_id"
  end

  create_table "group_posts", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "member_id", null: false
    t.string "title", null: false
    t.text "body"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.boolean "visible_to_non_members", default: false, null: false
    t.integer "like_count", default: 0, null: false
    t.datetime "posted_at"
    t.datetime "published_at"
    t.datetime "last_commented_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_posts_on_group_id"
    t.index ["member_id"], name: "index_group_posts_on_member_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "slug", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.integer "owner_id", null: false
    t.integer "user_count", default: 0, null: false
    t.integer "post_count", default: 0, null: false
    t.datetime "last_posted_at"
    t.boolean "is_owner_visible", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "information", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.boolean "is_public", default: true, null: false
    t.datetime "published_at"
    t.boolean "is_pinned", default: false, null: false
    t.integer "sort_order", default: 999, null: false
    t.integer "admin_id", null: false
    t.string "audience", default: "all"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_information_on_admin_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_post_comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "user_post_id", null: false
    t.text "body", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.integer "parent_comment_id"
    t.datetime "replied_at"
    t.integer "like_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_post_comments_on_user_id"
    t.index ["user_post_id"], name: "index_user_post_comments_on_user_post_id"
  end

  create_table "user_posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.text "body"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.boolean "deleted_due_to_parent", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "hidden_on_parent_restore", default: false, null: false
    t.boolean "is_pinned", default: false, null: false
    t.integer "sort_order", default: 999, null: false
    t.integer "like_count", default: 0, null: false
    t.datetime "posted_at"
    t.datetime "published_at"
    t.datetime "last_commented_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "nickname", null: false
    t.string "bio", null: false
    t.integer "user_status", default: 0, null: false
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.integer "deleted_reason"
    t.integer "login_count", default: 0, null: false
    t.integer "user_post_count", default: 0, null: false
    t.integer "user_post_comment_count", default: 0, null: false
    t.datetime "last_user_posted_at"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_notes", "admins"
  add_foreign_key "group_events", "group_memberships", column: "member_id"
  add_foreign_key "group_events", "groups"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "group_notices", "group_memberships", column: "member_id"
  add_foreign_key "group_notices", "groups"
  add_foreign_key "group_post_comments", "group_memberships", column: "member_id"
  add_foreign_key "group_post_comments", "group_posts"
  add_foreign_key "group_posts", "group_memberships", column: "member_id"
  add_foreign_key "group_posts", "groups"
  add_foreign_key "information", "admins"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_post_comments", "user_posts"
  add_foreign_key "user_post_comments", "users"
  add_foreign_key "user_posts", "users"
end
