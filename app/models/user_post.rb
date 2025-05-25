class UserPost < ApplicationRecord
  belongs_to :user
  has_many :user_post_comments, dependent: :destroy
  
  acts_as_taggable_on :tags
  acts_as_taggable_on :user_post_tags

  has_one_attached :user_post_image

  scope :with_deleted, -> { all }
  scope :only_deleted, -> { where(is_deleted: true) }


  # 空の場合、長さはスキップする
  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }  

  # 投稿作成時に必ずデフォルト画像を設定
  after_create :set_default_user_post_image

  # 投稿論理削除・非公開時に関連コメントも非公開または削除
  after_update :cascade_hide_comments_if_unpublished_or_deleted, 
    if: :saved_change_to_is_deleted_or_is_published?

  # ここにRansackableの設定(検索可能な属性)を追加します
  # attributesがカラムなどの本体情報、associationsは関連
  def self.ransackable_attributes(auth_object = nil)
    ["title", "body"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    []
  end

  private
  
  # デフォルトの画像をアタッチ
  def set_default_user_post_image
    # アタッチされた画像がある場合デフォルト画像をアタッチしない
    unless user_post_image.attached?
      # デフォルト画像のパスを指定
      default_image_path = Rails.root.join('app', 'assets', 'images', 'no_user_post.png')
      # content_typeはMIMEタイプを指しており、MIMEタイプはimage/jpeg(.jpgは拡張子なのであまりよろしくない)らしい)
      user_post_image.attach(io: File.open(default_image_path), 
        filename: 'no_user_post.png', content_type: 'image/png')
    end
  end

  def saved_change_to_is_deleted_or_is_published?
    saved_change_to_is_deleted? || saved_change_to_is_public?
  end

  def cascade_hide_comments_if_unpublished_or_deleted
    if is_deleted || !is_public
      user_post_comments.find_each do |comment|
        comment.update(hidden_by_parent: true)
      end
    else
      user_post_comments.find_each do |comment|
        comment.update(hidden_by_parent: false)
      end
    end
  end
end
