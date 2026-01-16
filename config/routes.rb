Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:show, :create]
      resources :customers, only: [:show, :create] do
        collection do
          post :migrate
        end
      end
      resources :subscriptions, only: [:create]
      
      namespace :webhooks do
        post :pagarme
      end
    end
  end
end
