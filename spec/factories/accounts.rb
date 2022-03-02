FactoryBot.define do
  factory :account do
    balance { 100 }
    title { 100 }
    account_number { Random.rand(9999999999999) }
    user
  end
end