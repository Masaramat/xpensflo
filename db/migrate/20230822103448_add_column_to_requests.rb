class AddColumnToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :trx_code, :string
  end
end
