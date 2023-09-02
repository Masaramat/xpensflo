class AddRequestIdToRejections < ActiveRecord::Migration[7.0]
  def change
    add_reference :rejections, :request, null: false, foreign_key: true
  end
end
