# frozen_string_literal: true

module Api
  module V1
    module Accounts
      # TransactionHistory API for Accounts
      class TransactionHistoryController < BaseController
        def index
          render json: collection.results[:results],
                 meta: { pagination_info: collection.results[:pagination_info] },
                 each_serializer: TransactionSerializer,
                 adapter: :json,
                 status: :ok
        end

        private

        def collection
          @collection ||= TransactionsCollection.new(
            Transaction.all,
            params
          )
        end

        def account
          current_user.account.find(params[:account_id])
        end
      end
    end
  end
end
