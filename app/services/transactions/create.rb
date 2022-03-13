# frozen_string_literal: true

module Transactions
  # Service for Transactions creation
  class Create
    include ResponseHandler

    attr_reader :user, :params, :response

    def self.call(user, params)
      new(user, params).tap(&:call)
    end

    def initialize(user, params)
      @user = user || User.first
      @params = params
      @response = {}
    end

    def call
      return success_response if Transaction.exists?(request_digest: params[:request_digest])

      handle_exception do
        Redis.current.lock('transaction_create') do
          Transaction.transaction do
            Transaction.create!(transfer_params)
            update_sender_balance
            update_recipient_balance
          end
        end

        success_response
      end
    end

    private

    def handle_success
      handle_response(success: true, message: 'Transfer created successfully!')
    end

    def transfer_params
      {
        sender: sender_account,
        recipient: recipient_account,
        amount: params[:amount],
        request_digest: params[:request_digest]
      }
    end

    def sender_account
      @sender_account ||= user.accounts.find(params[:sender_id])
    end

    def recipient_account
      @recipient_account ||= Account.find(params[:recipient_id])
    end

    def update_sender_balance
      sender_account.decrement!(:balance, params[:amount])
    end

    def update_recipient_balance
      recipient_account.increment!(:balance, params[:amount])
    end
  end
end
