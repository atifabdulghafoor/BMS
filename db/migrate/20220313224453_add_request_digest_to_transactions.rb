class AddRequestDigestToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :request_digest, :string, null: false
    add_index :transactions, :request_digest, unique: true
  end
end
