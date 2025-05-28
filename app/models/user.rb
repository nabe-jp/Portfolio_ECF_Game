class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # 現在未実装(Gemインストール済み)
  # acts_as_taggable_on :user_tags

  has_many :user_posts, dependent: :destroy
  has_many :user_post_comments, dependent: :destroy

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :user
  has_many :joined_groups, through: :group_memberships, source: :group
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id"
  has_many :group_posts, dependent: :destroy

  has_one_attached :profile_image

  # 多くの実在英語名が20〜30文字未満ですがまれに非常に長い名前も存在し、複数名・複合姓(スペースなど)も考慮し50文字
  validates :last_name, presence: { message: "を入力してください" }
  validates :last_name, length: { maximum: 50,
    message: "は1～50文字以内で入力してください" }, if: -> { last_name.present? }

  validates :first_name, presence: { message: "を入力してください" }
  validates :last_name, length: { maximum: 50,
    message: "は1～50文字以内で入力してください" }, if: -> { first_name.present? }

  validates :nickname, presence: { message: "を入力してください" }
  validates :nickname, length: { maximum: 10,
    message: "は1～10文字以内で入力してください" }, if: -> { nickname.present? }
  
  validates :bio, presence: { message: "を入力してください" }
  validates :bio, length: { maximum: 100,
    message: "は1～100文字以内で入力してください" }, if: -> { bio.present? }

  scope :active, -> { where(is_deleted: false, is_public: true, hidden_by_parent: false) }

  # ユーザー作成時にデフォルト画像を設定
  after_create :set_default_profile_image

  # ユーザー論理削除時に紐づく関連投稿やコメントの非公開、また復元時の復元処理
  after_update :cascade_hide_children_if_deleted, if: :saved_change_to_is_deleted?

  # シードデータ作成時にコールバックを実行しないようにするフラグ
  def seeding?
    defined?($skip_callbacks) && $skip_callbacks
  end

  # ここにRansackableの設定(検索可能な属性)を追加(現在未使用のためコメント化)
  # attributesがカラムなどの本体情報、associationsは関連
  # def self.ransackable_attributes(auth_object = nil)
  #   ["nickname", "bio", "user_tags"]
  # end
  
  # def self.ransackable_associations(auth_object = nil)
  #   []
  # end

  private

  # デフォルトの画像をアタッチ
  def set_default_profile_image
    # デフォルト画像のパスを指定
    default_image_path = Rails.root.join('app', 'assets', 'images', 'no_user.png')
    # content_typeはMIMEタイプを指しており、MIMEタイプはimage/jpeg(.jpgは拡張子なのであまりよろしくない)らしい)
    profile_image.attach(io: File.open(default_image_path), 
      filename: 'no_user.png', content_type: 'image/png')
  end
end