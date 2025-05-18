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
    # usersを作成しているためこのままではusersのコントローラーを使用するのでcontrollerを設定
    # :idは付きませんがユーザーに対する操作であることを明示的にするためにmemberを使用しています
    resource :user, only: [:show, :edit, :update], controller: 'user' do
      member do
        get 'mypage'
        get 'settings'
        get 'check'
        patch 'withdraw'
      end
    end
    
    # showはresource_userにもあるのでuser_post_pathに配置される、そこでは衝突が起こるのでpathを設定しています
    # リソースフルにするために投稿はresource_userにネストせずresources_usersにネストしました
    resources :users, only: [] do
      member do
        get 'show', as: 'show'
      end
      resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    end

    # ユーザーの全投稿用(indexだけのためresourcesは使用せずカスタム)
    get 'users/posts', to: 'posts#index', as: 'user_all_posts'

    # 検索
    resources :searches, only: [:index]



    # 他の会員用ルーティング
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: "dashboard#top"


    resources :searches, only: [:index]

    # リンクをテストするためのページ
    get 'button/test', to: 'button#test', as: 'button_test'
    # 他の管理用ルーティング
  end
end