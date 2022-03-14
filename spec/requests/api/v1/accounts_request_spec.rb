# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :request do
  describe 'POST #create' do
    subject(:create_account) do
      post api_v1_accounts_path, headers: auth_headers, params: params
    end

    let(:user) { create(:user) }
    let(:auth_headers) { user.create_new_auth_token }
    let(:balance) { 100 }
    let(:params) do
      {
        account: {
          balance: balance,
        }
      }
    end

    context 'when user is not logged in' do
      let(:auth_headers) { nil }

      before do
        create_account
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
        create_account
      end

      shared_examples 'unprocessable_entity' do
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'when params are valid' do
        let(:account) { Account.last }

        it { expect(response).to have_http_status(:ok) }
        it { expect(parsed_response['message']).to eq('Account created successfully!') }
        it { expect(account.balance).to eq(balance) }
        it { expect(account.account_number).to be_present }
        it { expect(account.title).to eq(user.name) }
      end

      context 'when balance is invalid' do
        let(:balance) { -1 }

        it_behaves_like 'unprocessable_entity'
      end
    end
  end
end
