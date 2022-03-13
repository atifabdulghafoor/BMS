# frozen_string_literal: true

# Table: Accounts
class Account < ApplicationRecord
  belongs_to :user

  has_many :sent_transactions, foreign_key: 'sender_id', class_name: 'Transaction', dependent: :destroy
  has_many :recieved_transactions, foreign_key: 'recipient_id', class_name: 'Transaction', dependent: :destroy

  validates :title, :account_number, :balance, presence: true
  validates :account_number, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0.0 }

  def transactions
    sent_transactions.or(recieved_transactions)
  end
end
