# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe 'POST #create' do
    subject(:create_transaction) do
      post :create, params: params
    end

    let(:user) { account.user }
    let(:account) { create(:account) }
    let(:account1) { create(:account) }
    let(:params) do
      {
        transaction: {
          sender_id: account.id,
          recipient_id: account1.id,
          amount: amount
        }
      }
    end

    let(:amount) { 120 }

    context 'when user is not logged in' do
    end

    context 'when user is logged in' do
      before do
        sign_in user
        create_transaction
      end

      it ' creates transaction' do
      end

      it 'deducts sender balance' do
      end

      it 'increases recipient balance' do
      end
    end
  end
end
