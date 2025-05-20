class Post < ApplicationRecord
  belongs_to :user

  acts_as_taggable_on :tags
  acts_as_taggable_on :user_post_tags

  has_one_attached :post_image


  # 空の場合、長さはスキップする
  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 20, 
    message: "は1～20文字以内で入力してください" }, if: -> { title.present? }
  
  validates :body, presence: { message: "を入力してください" }
  validates :body, length: { maximum: 200, 
    message: "は1～200文字以内で入力してください" }, if: -> { body.present? }  


  # 投稿作成時に必ずデフォルト画像を設定
  after_create :set_default_post_image

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
  def set_default_post_image
    # アタッチされた画像がある場合デフォルト画像をアタッチしない
    unless post_image.attached?
      # デフォルト画像のパスを指定
      default_image_path = Rails.root.join('app', 'assets', 'images', 'no_image.jpeg')
      # content_typeはMIMEタイプを指しており、MIMEタイプはimage/jpeg(.jpgは拡張子なのであまりよろしくない)らしい)
      post_image.attach(io: File.open(default_image_path), 
        filename: 'no_image.jpeg', content_type: 'image/jpeg')
    end
  end
end
