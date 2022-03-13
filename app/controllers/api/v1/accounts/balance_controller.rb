# frozen_string_literal: true

module Api
  module V1
    module Accounts
      # Balance API for Accounts
      class BalanceController < BaseController
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
