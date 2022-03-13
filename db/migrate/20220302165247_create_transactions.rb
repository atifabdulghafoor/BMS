# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :sender, index: true, foreign_key: { to_table: :accounts }
      t.references :recipient, index: true, foreign_key: { to_table: :accounts }
      t.decimal :amount, null: false

      t.timestamps
    end
  end
end
