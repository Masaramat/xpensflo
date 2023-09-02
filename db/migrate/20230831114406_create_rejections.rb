class CreateRejections < ActiveRecord::Migration[7.0]
  def change
    create_table :rejections do |t|
      t.string :reason
      t.references :user, foreign_key: true    

      t.timestamps
    end
  end
end
