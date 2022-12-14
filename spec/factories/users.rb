# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'abc' }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
