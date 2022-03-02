FactoryBot.define do
  factory :user do
    name { 'abc' }
    email { 'abc@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end