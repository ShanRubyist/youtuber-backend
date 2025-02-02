Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers:
    { omniauth_callbacks: 'users/omniauth_callbacks' }

  # require 'sidekiq/web'
  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users/sessions#new"

  post 'token', to: 'users/omniauth_callbacks#token'
  post 'google_onetap_token', to: 'users/google_one_tap#token'

  post 'stripe_checkout', to: 'payment#stripe_checkout', as: 'stripe_checkout'
  get 'stripe_billing', to: 'payment#stripe_billing', as: 'billing'
  post 'paddle_customer', to: 'payment#paddle_customer', as: 'paddle_customer'
  get 'charges_history', to: 'payment#charges_history', as: 'charges_history'

  # 跨域预检请求
  match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]

  namespace :api do
    namespace :v1 do

      get 'user_info',to: 'info#user_info'
      get 'dynamic_urls',to: 'info#dynamic_urls'
      get 'payment_info',to: 'info#payment_info'
      post 'log_client_error', to: 'info#log_client_error'
      get 'active_subscription_info', to: 'info#active_subscription_info', as: 'active_subscription_info'

      resources :info do
        collection do

        end
      end

      namespace :admin do
        resources :dashboard do
          collection do
            get 'staticstics_info' => 'dashboard#statistics_info'
          end
        end
      end

    end
  end
end
