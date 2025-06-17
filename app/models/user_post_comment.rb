class UserPostComment < ApplicationRecord
  include Scopes::Admin::Filters
  include Scopes::Public::Users
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :user
  belongs_to :user_post

  # 親コメント(返信先)との関連
  belongs_to :parent_comment, class_name: "UserPostComment", optional: true
  has_many :replies, class_name: "UserPostComment", foreign_key: :parent_comment_id, dependent: :destroy

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 50, 
    message: "は1～50文字以内で入力してください" }, if: -> { body.present? }

  after_create :update_post_timestamps

  private

  def update_post_timestamps
    if parent_comment.present?
      # 返信コメントが作成された時は、親コメントのreplied_atを更新
      parent_comment.update(replied_at: Time.current)
    else
      # 新規コメントが作成された時は、投稿のlast_commented_atを更新
      user_post.update(last_commented_at: Time.current)
    end
  end
end