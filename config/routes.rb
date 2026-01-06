Rails.application.routes.draw do
  get 'posts/new'
  get 'posts/create'
  get 'posts/show'
  get 'posts/edit'
  get 'posts/update'
  get 'posts/destroy'
  get 'homes/about'
  devise_for :users
  
  root to: "teams#index"
  
  resources :teams, only: [:index, :show] do
    resources :posts, except: [:index]
  end

  get 'about', to: 'homes#about', as: 'about'
end