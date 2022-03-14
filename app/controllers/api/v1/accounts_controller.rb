# frozen_string_literal: true

module Api
  module V1
    # Accounts API
    class AccountsController < BaseController
      def create
        handler = ::Accounts::Create.call(current_user, account_params)
        render json: handler.response, status: handler.response[:status]
      end

      private

      def account_params
        params.require(:account).permit(:balance)
      end
    end
  end
end
