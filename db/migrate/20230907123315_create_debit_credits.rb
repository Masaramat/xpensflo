class CreateDebitCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :debit_credits do |t|
      t.decimal :amount
      t.string :amount_in_words
      t.bigint :dr_account
      t.bigint :cr_account
      t.string :dr_account_name
      t.string :cr_account_name
      t.integer :trx_type
      t.string :dr_narration
      t.string :cr_narration
      t.references :initiated_by, foreign_key: { to_table: :users }
      t.timestamp :initiated_at, null: true 
      t.references :approved_by, foreign_key: { to_table: :users }
      t.timestamp :approved_at, null: true
      t.integer :status, default: 0 

      t.timestamps
    end
  end
end
