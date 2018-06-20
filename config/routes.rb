Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      omniauth_callbacks: "users/omniauth_callbacks"
    }
  end
end
