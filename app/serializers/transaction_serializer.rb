class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :sender_account_number, :recipient_account_number,
             :amount, :created_at

  def sender_account_number
    object.sender_account_number
  end

  def recipient_account_number
    object.recipient_account_number
  end
end
