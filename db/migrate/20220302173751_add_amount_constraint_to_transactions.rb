class AddAmountConstraintToTransactions < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE transactions ADD CONSTRAINT amount_check CHECK (amount > 0)"
  end

  def down
    execute "ALTER TABLE transactions DROP CONSTRAINT amount_check"
  end
end
