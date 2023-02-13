Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'users/' => 'users#abc'
  resources :users # ユーザーマイページへのルーティング

  resources :posts do
    resources :likes, only: [:create, :destroy]

    resources :comments, only: [:create]

  end

  get 'posts/:post_id/likes' => 'likes#create'
  get 'posts/:post_id/likes/:id' => 'likes#destroy'

  root 'posts#index'

end
