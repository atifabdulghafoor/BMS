module Api
  module V1
    module Accounts
      class TransactionHistoryController < ApplicationController
        before_action :authenticate_user!

        def index
          render json: collection, status: :ok
        end 

        private

        def collection
          # TODO: use serializer here
          account.transactions
        end

        def account
          current_user.account.find(params[:account_id])
        end
      end
    end
  end
end