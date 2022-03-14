# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject(:transaction) { create(:transaction) }

  describe 'associations' do
    it { should belong_to(:sender).class_name('Account') }
    it { should belong_to(:recipient).class_name('Account') }
  end

  describe 'validations' do
    it { should validate_presence_of(:request_digest) }
    it { should validate_uniqueness_of(:request_digest) }
    it do
      should validate_numericality_of(:amount)
        .is_greater_than(0.0)
    end
  end

  describe 'delegates' do
    it { should delegate_method(:account_number).to(:sender).with_prefix }
    it { should delegate_method(:account_number).to(:recipient).with_prefix }
  end
end
