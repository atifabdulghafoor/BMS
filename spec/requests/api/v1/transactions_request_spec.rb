# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do
  describe 'POST #create' do
    subject(:create_transaction) do
      post api_v1_transactions_path, headers: auth_headers, params: params
    end

    let(:user) { account.user }
    let(:auth_headers) { user.create_new_auth_token }
    let(:account) { create(:account, balance: initial_balance) }
    let(:account1) { create(:account, balance: initial_balance) }
    let(:amount) { 20 }
    let(:initial_balance) { 100 }
    let(:sender_id) { account.id }
    let(:recipient_id) { account1.id }
    let(:params) do
      {
        transaction: {
          sender_id: sender_id,
          recipient_id: recipient_id,
          amount: amount,
          request_digest: SecureRandom.hex
        }
      }
    end

    context 'when user is not logged in' do
      let(:auth_headers) { nil }

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
        create_transaction

        account.reload
        account1.reload
      end

      shared_examples 'unprocessable_entity' do
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'when params are valid' do
        it { expect(response).to have_http_status(:ok) }
        it { expect(parsed_response['message']).to eq('Transfer created successfully!') }
        it { expect(transaction.sender).to eq(account) }
        it { expect(transaction.recipient).to eq(account1) }
        it { expect(transaction.amount).to eq(amount) }
        it { expect(account.balance).to eq(initial_balance - amount) }
        it { expect(account1.balance).to eq(initial_balance + amount) }
      end

      context 'when sender is invalid' do
        let(:sender_id) { 9_999 }
        it_behaves_like 'unprocessable_entity'
      end

      context 'when sender is invalid' do
        let(:recipient_id) { 9_999 }
        it_behaves_like 'unprocessable_entity'
      end

      context 'when amount is invalid' do
        let(:amount) { 9_999 }
        it_behaves_like 'unprocessable_entity'
      end
    end
  end
end
