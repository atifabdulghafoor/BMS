# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { 100 }
    request_digest { SecureRandom.hex }
    association :sender, factory: :account
    association :recipient, factory: :account
  end
end
