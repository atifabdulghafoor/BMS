# frozen_string_literal: true

# Collection for Transactions filtering
class TransactionsCollection < BaseCollection
  def ensure_filters
    filter_by_account if params[:account_id].present?
  end

  private

  def filter_by_account
    filter do
      account.transactions
    end
  end

  def account
    Account.find params[:account_id]
  end
end
