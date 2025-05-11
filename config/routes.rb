Rails.application.routes.draw do
  # ネストが深くなると可読性、保守性が下がるので命名を短くしました
  # その為、同じ名前が出てくるのでパスプレフィックス(/users, /groups)にてルートを分けています

  # 会員側
  devise_for :users, skip: [:passwords, :cancel], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者側
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 会員用ルーティング
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'

    # マイページは個人情報を取り扱い、自分の設定の変更はほかのユーザーはしないのでidを持たないように設計
    # deviseとurlがかさなるので'users/profile'に変更
    resource :users, only: [:edit, :update, :destroy] , path: 'users/profile'
    get 'users/mypage', to: 'users#mypage', as: 'user_mypage'
    get 'users/settings', to: 'users#settings', as: 'user_settings'
    get 'users/check', to: 'users#check', as: 'user_check'
    patch  'users/withdraw', to: 'users#withdraw', as: 'user_withdraw'

    # ほかのユーザーの投稿を見るため
    resources :users, only: [:show] do
      resources :posts, only: [:new, :index, :show, :create, :edit, :update, :destroy]
    end

    resources :posts, only: [:index]
    # 他の会員用ルーティング
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: "dashboard#top"
    # 他の管理用ルーティング
  end
end