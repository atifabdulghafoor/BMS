# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Accounts::TransactionHistoryController, type: :request do
  describe 'Get #show' do
    subject(:get_transaction_history) do
      get api_v1_account_transaction_history_path(account_id: account.id),
          headers: auth_headers
    end

    let(:user) { account.user }
    let(:auth_headers) { user.create_new_auth_token }
    let(:account) { create(:account) }
    let!(:transaction1) do
      create(:transaction,
             recipient: create(:account),
             sender: account,
             amount: 10)
    end

    let!(:transaction2) do
      create(:transaction,
             recipient: account,
             sender: create(:account),
             amount: 10)
    end

    let!(:transaction3) do
      create(:transaction,
             recipient: create(:account),
             sender: create(:account),
             amount: 10)
    end

    before do
      get_transaction_history
    end

    context 'when user is not logged in' do
      let(:auth_headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
      it do
        expect(parsed_response['errors']).to eq(
          ['You need to sign in or sign up before continuing.']
        )
      end
    end

    context 'when user is logged in' do
      let(:transactions) do
        parsed_response['transactions']
      end

      let(:transactions_ids) do
        transactions.pluck('id').sort
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(parsed_response['meta']['pagination_info']).to be_present }
      it { expect(transactions.count).to eq(2) }
      it do
        expect(transactions_ids).to eq(
          [transaction1.id, transaction2.id].sort
        )
      end

      it do
        expect(transactions_ids).not_to include(
          transaction3.id
        )
      end
    end
  end
end
