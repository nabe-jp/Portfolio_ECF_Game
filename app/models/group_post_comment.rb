class GroupPostComment < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  BODY_MIN_LENGTH = 1
  BODY_MAX_LENGTH = 50

  include Scopes::Admin::Filters
  include Scopes::Public::Groups
  include Scopes::Shared::Ordering
  include DeletableReason
  
  belongs_to :group_post
  belongs_to :member, class_name: "GroupMembership"

  belongs_to :parent_comment, class_name: 'GroupPostComment', optional: true
  has_many :replies, class_name: 'GroupPostComment', foreign_key: :parent_comment_id, dependent: :destroy

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { 
    minimum: BODY_MIN_LENGTH, maximum: BODY_MAX_LENGTH,
    message: "は#{BODY_MIN_LENGTH}～#{BODY_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { body.present? }

  after_create :update_post_timestamps

  private

  def update_post_timestamps
    if parent_comment.present?
      # 返信コメントが作成された時は、親コメントのreplied_atを更新
      parent_comment.update(replied_at: Time.current)
    else
      # 新規コメントが作成された時は、投稿のlast_commented_atを更新
      group_post.update(last_commented_at: Time.current)
    end
  end
end
