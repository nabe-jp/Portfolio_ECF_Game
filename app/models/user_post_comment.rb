class UserPostComment < ApplicationRecord
  belongs_to :user
  belongs_to :user_post

  # 親コメント（返信先）との関連
  belongs_to :parent_comment, class_name: "UserPostComment", optional: true
  has_many :replies, class_name: "UserPostComment", foreign_key: :parent_comment_id, dependent: :destroy

  scope :with_deleted, -> { all }
  scope :only_deleted, -> { where(is_deleted: true) }

  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 50, 
    message: "は1～50文字以内で入力してください" }, if: -> { body.present? }
    
  # コメントが作成された後に、親が非公開/削除されていたら自動で非表示に
  after_create :check_parent_visibility
    
  # 親の非表示/復元を受けて非表示/表示を切り替える処理
  def cascade_hide_or_unhide(hidden)
    update(hidden_by_parent: hidden)
    replies.each do |reply|
      reply.cascade_hide_or_unhide(hidden)
    end
  end

  private

  def check_parent_visibility
    if user_post.hidden_by_parent || !user_post.is_public || user_post.is_deleted || 
        user.hidden_by_parent || user.is_deleted
      update(hidden_by_parent: true)
    end
  end
end