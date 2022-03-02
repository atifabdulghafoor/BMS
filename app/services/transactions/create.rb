module Transactions
  class Create
    include ResponseHandler
    
    attr_reader :user, :params, :response

    def self.call(user, params)
      new(user, params).tap(&:call)
    end

    def initialize(user, params)
      @user = user
      @params = params
      @response = {}
    end

    def call
      handle_exception do
        Redis.current.lock('transaction_create') do
          Transaction.transaction do
            Transaction.create!(transfer_params)
            update_sender_balance
            update_recipient_balance
          end
        end
        handle_response(success: true, message: 'Transfer created successfully!')
      end
    end

    private

    def transfer_params
      {
        sender: sender_account,
        recipient: recipient_account,
        amount: params[:amount]
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
