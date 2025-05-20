class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  acts_as_taggable_on :user_tags

  has_one_attached :profile_image
  
  validates :last_name, :first_name, :nickname, :bio, presence: true      # 空でない
  validates :last_name, :first_name, length: { maximum: 20 }              # 1～20文字
  validates :nickname, length: { maximum: 10 }                            # 1～10文字
  validates :bio, length: { maximum: 50 }                                 # 1～50文字


  # ユーザー作成時にデフォルト画像を設定
  after_create :set_default_profile_image

  # シードデータ作成時にコールバックを実行しないようにするフラグ
  def seeding?
    defined?($skip_callbacks) && $skip_callbacks
  end

  # ここにRansackableの設定(検索可能な属性)を追加します
  # attributesがカラムなどの本体情報、associationsは関連
  def self.ransackable_attributes(auth_object = nil)
    ["nickname", "bio", "user_tags"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    []
  end

  
  private

  # デフォルトの画像をアタッチ
  def set_default_profile_image
    # デフォルト画像のパスを指定
    default_image_path = Rails.root.join('app', 'assets', 'images', 'no_image.jpeg')
    # content_typeはMIMEタイプを指しており、MIMEタイプはimage/jpeg(.jpgは拡張子なのであまりよろしくない)らしい)
    profile_image.attach(io: File.open(default_image_path), 
      filename: 'no_image.jpeg', content_type: 'image/jpeg')
  end
end