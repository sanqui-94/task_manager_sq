Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "board#show"

  get "archive", to: "archive#index", as: :archive

  resources :tasks, param: :code, only: %i[ show new create update ] do
    member do
      patch :archive
      patch :unarchive
    end

    resources :comments, only: :create
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
