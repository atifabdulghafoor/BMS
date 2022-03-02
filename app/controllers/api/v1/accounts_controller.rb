module Api
  module V1
    class AccountsController < ApplicationController
      before_action :authenticate_user!

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