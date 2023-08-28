# 20230818171906_create_requests.rb
class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.decimal :amount
      t.references :account, foreign_key: true
      t.references :requested_by, foreign_key: { to_table: :users }
      t.references :vetted_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.references :cleared_by, foreign_key: { to_table: :users }
      t.references :paid_by, foreign_key: { to_table: :users }
      t.text :comment
      t.text :narration
      t.timestamps
    end
  end
end
