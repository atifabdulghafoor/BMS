# frozen_string_literal: true

module Accounts
  # Service for Accounts creation
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
        user.accounts.create!(account_params)
        handle_response(success: true, message: 'Account created successfully!')
      end
    end

    private

    def account_params
      params.merge(
        title: user.name,
        account_number: account_number
      )
    end

    def account_number
      loop do
        @account_number = Random.rand(99_999_999_999_999)

        break unless Account.exists?(account_number: @account_number)
      end

      @account_number
    end
  end
end
