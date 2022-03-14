# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe 'POST #create' do
    let(:create_transaction) do
      post :create, params: params
    end

    let(:user) { account.user }
    let(:auth_headers) { user.create_new_auth_token }
    let(:account) { create(:account, balance: initial_balance) }
    let(:account1) { create(:account, balance: initial_balance) }
    let(:amount) { 20 }
    let(:initial_balance) { 100 }
    let(:params) do
      {
        transaction: {
          sender_id: account.id,
          recipient_id: account1.id,
          amount: amount,
          request_digest: SecureRandom.hex
        }
      }
    end

    context 'when user is not logged in' do
      before do
        create_transaction
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it do
        expect(parsed_response['errors']).to eq(
          ['You need to sign in or sign up before continuing.']
        )
      end
    end

    context 'when user is logged in' do
      let(:transaction) { Transaction.last }

      before do
        request.headers.merge! auth_headers

        create_transaction

        account.reload
        account1.reload
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(parsed_response['message']).to eq('Transfer created successfully!') }
      it { expect(transaction.sender).to eq(account) }
      it { expect(transaction.recipient).to eq(account1) }
      it { expect(transaction.amount).to eq(amount) }
      it { expect(account.balance).to eq(initial_balance - amount) }
      it { expect(account1.balance).to eq(initial_balance + amount) }
    end
  end
end
