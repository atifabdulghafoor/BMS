# frozen_string_literal: true

module Api
  module V1
    # Transactions API
    class TransactionsController < BaseController
      def create
        handler = Transactions::Create.call(current_user, transaction_params)
        render json: handler.response
      end

      private

      def transaction_params
        params.require(:transaction).permit(:sender_id, :recipient_id,
                                            :amount, :request_digest)
      end
    end
  end
end
