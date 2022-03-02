module Api
  module V1
    module Accounts
      class BalanceController < ApplicationController
        before_action :authenticate_user!

        def show
          render json: { balance: balance }, status: :ok
        end 

        private

        def balance
          account.balance
        end

        def account
          current_user.account.find(params[:account_id])
        end
      end
    end
  end
end