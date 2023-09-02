class ChangeTrfAccountNoDataType < ActiveRecord::Migration[7.0]
  def change
    change_column :requests, :trf_account_no, :bigint
  end
end
