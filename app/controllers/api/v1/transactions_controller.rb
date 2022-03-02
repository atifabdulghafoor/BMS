module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :authenticate_user!

      def create
        handler = Transactions::Create.call(current_user, transaction_params)
        render json: handler.response
      end 

      private

      def transaction_params
        params.require(:transaction).permit(:sender_id, :recipient_id, :amount)
      end
    end
  end
end