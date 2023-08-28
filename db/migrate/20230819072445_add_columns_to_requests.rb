class AddColumnsToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :payment_type, :integer, default: 0
    add_column :requests, :expense_type, :integer, default: 0
    add_column :requests, :vetted_at, :timestamp, null: true 
    add_column :requests, :approved_at, :timestamp, null: true
    add_column :requests, :cleared_at, :timestamp, null: true
    add_column :requests, :paid_at, :timestamp, null: true
  end
end
