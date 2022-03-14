# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Accounts::BalanceController, type: :request do
  describe 'Get #show' do
    subject!(:get_balance) do
      get api_v1_account_balance_path(account_id: account.id),
          headers: auth_headers
    end

    let(:user) { account.user }
    let(:auth_headers) { user.create_new_auth_token }
    let(:account) { create(:account, balance: balance) }
    let(:balance) { 100 }

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
      it { expect(response).to have_http_status(:ok) }
      it { expect(parsed_response).to eq({ 'balance' => '100.0' }) }
    end
  end
end
