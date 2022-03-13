# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    balance { 100 }
    title { 100 }
    account_number { Random.rand(9_999_999_999_999) }
    user
  end
end
