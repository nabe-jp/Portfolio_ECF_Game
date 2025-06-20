class User < ApplicationRecord
  # スコープの読み込み
  include Scopes::Admin::Filters
  include Scopes::Public::Users
  include Scopes::Shared::Ordering
  
  # 削除理由のenumの読み込み
  include DeletableReason

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # 現在未実装(Gemインストール済み)
  # acts_as_taggable_on :user_tags

  # ユーザーが作成したもの、削除された際に関連して削除される
  has_many :user_posts, dependent: :destroy
  has_many :user_post_comments, dependent: :destroy

  # グループに関連するアソシエーション
  # GroupMembershipとアソシエーション、Userがメンバー又はオーナーであるグループを取得できるよう定義
  has_many :group_memberships, dependent: :destroy
  has_many :joined_groups, through: :group_memberships, source: :group
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id"

  # 上記のアクティブなものを定義(メンバーまたはオーナーとして参加・所有していて脱退していないもの)
  has_many :active_group_memberships, -> { active_members }, class_name: 'GroupMembership'
  has_many :active_joined_groups, through: :active_group_memberships, source: :group

  has_one_attached :profile_image

  # 利用中・退会済み・復元後非アクティブ・利用禁止・サイトによる凍結
  enum user_status: { active: 0, deactivated: 1, restored_pending: 2, banned: 3, suspended: 4 },
   _prefix: true

  # 多くの実在英語名が20〜30文字未満ですがまれに非常に長い名前も存在し、複数名・複合姓(スペースなど)も考慮し50文字
  validates :last_name, presence: { message: "を入力してください" }
  validates :last_name, length: { maximum: 50,
    message: "は1～50文字以内で入力してください" }, if: -> { last_name.present? }

  validates :first_name, presence: { message: "を入力してください" }
  validates :last_name, length: { maximum: 50,
    message: "は1～50文字以内で入力してください" }, if: -> { first_name.present? }

  validates :nickname, presence: { message: "を入力してください" }
  validates :nickname, length: { maximum: 20,
    message: "は1～20文字以内で入力してください" }, if: -> { nickname.present? }
  
  validates :bio, presence: { message: "を入力してください" }
  validates :bio, length: { maximum: 100,
    message: "は1～100文字以内で入力してください" }, if: -> { bio.present? }

  # ユーザー作成時にデフォルト画像を設定(seed作成時は作動しないように設定)
  after_create :set_default_profile_image, unless: :seeding?

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
    default_image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_user.jpg')
    # content_typeはMIMEタイプを指しており、MIMEタイプはimage/jpeg(.jpgは拡張子なのであまりよろしくない)らしい)
    profile_image.attach(io: File.open(default_image_path), 
      filename: 'no_user.jpg', content_type: 'image/jpeg')
  end
end