# frozen_string_literal: true

# Table: Transactions
class Transaction < ApplicationRecord
  acts_as_paranoid

  belongs_to :sender, class_name: 'Account'
  belongs_to :recipient, class_name: 'Account'

  validates :amount, numericality: { greater_than: 0.0 }

  delegate :account_number, to: :sender, prefix: true
  delegate :account_number, to: :recipient, prefix: true
end
