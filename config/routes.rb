Rails.application.routes.draw do

# ユーザー用
devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
devise_scope :user do
  post 'public/users/guest_sign_in' => "public/users/sessions#guest_sign_in"git
end

scope module: :public do
  root to: "homes#top"
  get 'about' => "homes#about", as: 'about'

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => "relationships#followings", as: 'followings'
    get 'followers' => "relationships#followers", as: 'followers'
  end

  get 'users/:id/unsubscribe' => "users#unsubscribe", as: 'unsubscribe'
  patch 'users/:id/withdrawal' => "users#withdrawal", as: 'withdrawal'

  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :groups do
    get 'join' => "groups#join"
    delete 'all_destroy' => "groups#all_destroy"
  end

  resources :tags do
    get 'search_tag'=>"posts#search_tag"
  end
end

# 管理者用
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

namespace :admin do
  resources :users, only: [:index, :show]
end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
