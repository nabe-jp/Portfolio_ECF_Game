class UserPost < ApplicationRecord
  # バリデーションに使用する絶対値の定義(文字数)
  TITLE_MIN_LENGTH = 1
  TITLE_MAX_LENGTH = 20
  BODY_MIN_LENGTH = 1
  BODY_MAX_LENGTH = 200
  
  include Scopes::Admin::Filters
  include Scopes::Public::Users
  include Scopes::Shared::Ordering
  include DeletableReason
  
  # 現在未実装(Gemインストール済み)
  acts_as_taggable_on :tags
  acts_as_taggable_on :user_post_tags

  belongs_to :user
  has_many :user_post_comments, dependent: :destroy

  has_one_attached :user_post_image

  # 空の場合、長さはスキップする
  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { 
    minimum: TITLE_MIN_LENGTH, maximum: TITLE_MAX_LENGTH,
    message: "は#{TITLE_MIN_LENGTH}～#{TITLE_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { 
    minimum: BODY_MIN_LENGTH, maximum: BODY_MAX_LENGTH,
    message: "は#{BODY_MIN_LENGTH}～#{BODY_MAX_LENGTH}文字以内で入力してください" 
  }, if: -> { body.present? }

  # 投稿作成時に必ずデフォルト画像を設定(seed作成時は作動しないように設定)
  after_create :set_default_user_post_image, unless: :seeding?

  private
  
  # デフォルトの画像をアタッチ
  def set_default_user_post_image
    # アタッチされた画像がある場合デフォルト画像をアタッチしない
    unless user_post_image.attached?
      # デフォルト画像のパスを指定
      default_image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_user_post.jpg')
      # content_typeはMIMEタイプを指しており、MIMEタイプはimage/jpeg(.jpgは拡張子なのであまりよろしくない)らしい)
      user_post_image.attach(io: File.open(default_image_path), 
        filename: 'no_user_post.jpg', content_type: 'image/jpeg')
    end
  end
end
