Rails.application.routes.draw do
  devise_for :users
  
  root to: "teams#index"
  
  resources :users, only: [:show] do
    collection do
      patch 'withdraw'
      get 'mypage'
    end
  end
  resources :teams, only: [:index, :show] do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
    end
  end
  resources :groups do
    resources :group_users, only: [:index, :create]
  end
  resources :group_users, only: [:update, :destroy]
  resources :reports, only: [:create]
  resources :players, only: [:show]

  get 'about', to: 'homes#about', as: 'about'
  get 'search', to: 'searches#index', as: 'search'

  namespace :admin do
    resources :posts, only: [:index, :destroy]
    resources :users, only: [:index, :update]
    resources :reports, only: [:index, :show, :update]
    resources :groups, only: [:destroy]
  end
end