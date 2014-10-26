Rails.application.routes.draw do
  get 'comments/create'

  root to: 'questions#index'
  devise_for :users
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
