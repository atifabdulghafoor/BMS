class AddBalanceConstraintToAccounts < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE accounts ADD CONSTRAINT balance_check CHECK (balance >= 0)"
  end

  def down
    execute "ALTER TABLE accounts DROP CONSTRAINT balance_check"
  end
end
