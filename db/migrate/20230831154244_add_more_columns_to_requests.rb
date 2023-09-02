class AddMoreColumnsToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :trf_account_name, :string
    add_column :requests, :trf_account_no, :integer
    add_column :requests, :trf_bank_name, :string
  end
end
