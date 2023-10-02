class AddColumnsToDebitCredit < ActiveRecord::Migration[7.0]
  def change
    add_column :debit_credits, :paid_at, :timestamp
    add_column :debit_credits, :cr_trx_code, :string
    add_column :debit_credits, :dr_trx_code, :string
    add_reference :debit_credits, :paid_by, null: true, foreign_key: { to_table: :users }
  end
end
