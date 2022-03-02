module Api
  module V1
    class TransactionsController < ApplicationController
      def create
        handler = Transactions::Create.call(current_user, transfer_params)
        render json: handler.response
      end 

      private

      def transfer_params
        params.require(:account).permit(:sender_id, :recipient_id, :amount)
      end
    end
  end
end