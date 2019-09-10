Rails.application.routes.draw do
  get "sessions/new"
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/, defaults: {locale: "en"}   do
    root "static_pages#home"

    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end
end
