Rails.application.routes.draw do
  namespace :admin do
    get 'users/index'
  end
  namespace :admin do
    get 'posts/index'
  end
  get 'searches/index'
  devise_for :users
  
  root to: "teams#index"
  
  resources :users, only: [:show] do
    collection do
      get 'mypage'
    end
  end
  resources :teams, only: [:index, :show] do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
    end
  end

  get 'about', to: 'homes#about', as: 'about'
  get 'search', to: 'searches#index', as: 'search'

  namespace :admin do
    resources :posts, only: [:index, :destroy]
    resources :users, only: [:index, :update]
  end
end