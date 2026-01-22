Rails.application.routes.draw do
  get 'group_users/index'
  get 'group_users/create'
  get 'group_users/update'
  get 'group_users/destroy'
  get 'groups/index'
  get 'groups/show'
  get 'groups/new'
  get 'groups/create'
  get 'groups/edit'
  get 'groups/update'
  get 'groups/destroy'
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
  resources :groups do
    resources :group_users, only: [:index, :create]
  end
  resources :group_users, only: [:update, :destroy]
  resources :reports, only: [:create]

  get 'about', to: 'homes#about', as: 'about'
  get 'search', to: 'searches#index', as: 'search'

  namespace :admin do
    resources :posts, only: [:index, :destroy]
    resources :users, only: [:index, :update]
    resources :reports, only: [:index, :show, :update]
  end
end