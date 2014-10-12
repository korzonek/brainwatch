Rails.application.routes.draw do
  get 'comments/create'

  root to: 'questions#index'
  devise_for :users
  concern :commentable do
    resources :comments, only: [:new, :create, :update]
  end

  resources :questions, concerns: :commentable do
    resources :answers, concerns: :commentable, shallow: true do
      member do
        post 'accept'
      end
    end
  end
end
