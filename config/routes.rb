Rails.application.routes.draw do
  # ネストが深くなると可読性、保守性が下がるので命名を短くしました
  # その為、同じ名前が出てくるのでパスプレフィックス(/users, /groups)にてルートを分けています

  Rails.application.routes.draw do
    # 新規会員登録時バリデーションなどでrenderすると/usersになるのでリロードしてもエラーが発生しないようにする
    get '/users', to: redirect('/users/sign_up')
  end

  # 会員側
  devise_for :users, skip: [:passwords], controllers: {
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

    # users/:id/mypageのURLを個別に設定
    get 'users/:id/mypage', to: 'users#mypage', as: 'user_mypage'
    get 'users/:id/withdraw_check', to: 'users#withdraw_check', as: 'user_withdraw_check'
    patch  'users/:id/withdraw', to: 'users#withdraw', as: 'user_withdraw'
    resources :users, only: [:show, :edit, :update, :destroy] do
      resources :posts, only: [:new, :index, :show, :create, :edit, :update, :destroy]
    end
    # 他の会員用ルーティング
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: "dashboard#top"
    # 他の管理用ルーティング
  end
end