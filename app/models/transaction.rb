class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'Account'
  belongs_to :recipient, class_name: 'Account'

  validates :amount, numericality: { greater_than: 0.0 }
end
