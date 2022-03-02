class Account < ApplicationRecord
  belongs_to :user

  validates :title, :account_number, :balance
  validates :account_number, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0.0 }
end
