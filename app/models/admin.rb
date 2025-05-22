class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Adminが削除された場合、admin_idをNULLにする(情報自体は削除しない)
  has_many :informations, dependent: :nullify
end