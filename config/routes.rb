Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants, only: [:index]
  get 'foodora', to: "restaurants#foodora"
  get 'deliveroo', to: "restaurants#deliveroo"
  post 'menus', to: "restaurants#show"

  get 'foodora_show', to: "restaurants#foodora_show"
  get 'deliveroo_show', to: "restaurants#deliveroo_show"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :restaurants, only: [ :index, :show ], param: :address
    end
  end
end


