class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  
  validates :last_name, :first_name, :nickname, :bio, presence: true      # 空でない
  validates :last_name, :first_name, length: { maximum: 20 }              # 1～20文字
  validates :nickname, length: { maximum: 10 }                            # 1～10文字
  validates :bio, length: { maximum: 50 }                                 # 1～50文字
end
