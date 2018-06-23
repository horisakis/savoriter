Rails.application.routes.draw do
  get 'contents/', to: 'contents#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, controllers: {
    # sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    authenticated :user do
      root :to => 'contents#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'static_pages#index', as: :unauthenticated_root
    end
  end

  resources :users, only: :index
  resources :auths, only: %i[index edit update destroy]
end
