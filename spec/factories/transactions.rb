FactoryBot.define do
  factory :transaction do
    amount { 100 }
    association :sender, factory: :account
    association :recipient, factory: :account
  end
end