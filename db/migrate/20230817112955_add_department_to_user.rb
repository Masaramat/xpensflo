class AddDepartmentToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :department, null: false, foreign_key: true
  end
end
