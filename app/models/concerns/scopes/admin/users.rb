# admin側のユーザーにて使用するスコープ
module Scopes::Admin::Users
  extend ActiveSupport::Concern

  included do
    scope :inactive_users, -> {
      where.not(user_status: :active)
    }
  end
end