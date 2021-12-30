class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.integer :amountAvailable
      t.integer :cost
      t.string :productName
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
