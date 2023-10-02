class AddColumnsToRequest < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :br_cleared_by, null: true, foreign_key: { to_table: :users }
    add_column :requests, :br_cleared_at, :timestamp, null: true 
  end
end
