class AddCustomCulumnsToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :account_name, :string
    add_column :requests, :account_no, :bigint
  end
end
