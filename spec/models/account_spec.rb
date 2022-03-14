# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { create(:account) }

  describe 'associations' do
    it { should belong_to(:user) }
    it do
      should have_many(
        :sent_transactions
      ).with_foreign_key(
        'sender_id'
      ).class_name('Transaction')
    end

    it do
      should have_many(
        :recieved_transactions
      ).with_foreign_key(
        'recipient_id'
      ).class_name('Transaction')
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:balance) }
    it { should validate_uniqueness_of(:account_number).case_insensitive }
    it do
      should validate_numericality_of(:balance)
        .is_greater_than_or_equal_to(0.0)
    end
  end

  describe '#transactions' do
    let(:transaction1) do
      create(:transaction,
             recipient: create(:account),
             sender: account,
             amount: 10)
    end

    let(:transaction2) do
      create(:transaction,
             recipient: account,
             sender: create(:account),
             amount: 10)
    end

    it do
      expect(account.transactions).to eq(
        account.sent_transactions.or(account.recieved_transactions)
      )
    end
  end
end
