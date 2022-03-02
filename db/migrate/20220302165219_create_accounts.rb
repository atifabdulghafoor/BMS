class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string :account_number, null: false
      t.string :title, null: false
      t.decimal :balance, null: false, default: 0.0

      t.timestamps
    end

    add_index :accounts, :account_number, unique: true
  end
end

