Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace 'v1' do
      resources :accounts, only: :create do
        get :balance, to: 'accounts/balance#show'
        get :transaction_history, to: 'accounts/transaction_history#index'
      end

      resources :transfers, only: :create
    end
  end
end
