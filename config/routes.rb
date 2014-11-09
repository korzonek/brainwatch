Rails.application.routes.draw do
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all ,on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  root to: 'questions#index'
  get 'comments/create'
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  devise_scope :user do
    post 'twitter_continue', to: 'omniauth_callbacks#twitter_continue'
  end

  concern :commentable do
    resources :comments, only: [:new, :create, :update, :destroy, :edit]
  end

  concern :votable do
    post 'upvote', to: 'votes#up'
    post 'downvote', to: 'votes#down'
    post 'resetvote', to: 'votes#reset'
  end

  resources :questions, concerns: [:commentable, :votable] do
    resources :answers, concerns: [:commentable, :votable], shallow: true do
      member do
        post 'accept'
      end
    end
  end

  resources :tags, only: [:index, :show]

end
