module Api
  module V1
    class AccountsController < ApplicationController
      def create
        handler = Accounts::Create.call(current_user, account_params)
        render json: handler.response
      end 

      private

      def account_params
        params.require(:account).permit(:balance)
      end
    end
  end
end