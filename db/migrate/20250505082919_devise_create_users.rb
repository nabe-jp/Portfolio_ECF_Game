# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # ユーザーで使用するカラムを追加
      # 基本情報
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :nickname, null: false
      t.string :bio, null: false

      # 状態制御(削除・非表示)
      t.integer :user_status, default: 0, null: false                   # ユーザーのステータス
      t.datetime :deleted_at                                            # 削除日時
      t.integer :deleted_by_id                                          # 削除した管理者 or 操作者のID
      t.integer :deleted_reason                                         # 削除理由(enumで管理)
      t.boolean :hidden_by_parent, default: false, null: false          # 関連元の削除/非公開による非表示

      # 統計情報・アクティビティ
      t.integer :login_count, default: 0, null: false                   # ログイン回数
      t.integer :user_post_count, default: 0, null: false               # 投稿数のキャッシュ
      t.integer :user_post_comment_count, default: 0, null: false       # コメント数のキャッシュ
      t.datetime :last_user_posted_at                                   # 最後に投稿した日時

      # 権限
      t.integer :role, default: 0, null: false                          # enumとして管理者や一般を識別可能化

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
