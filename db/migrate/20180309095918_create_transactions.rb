class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.float :transaction_amount, default: 0.0
      t.string :transaction_reference
      t.float :total_balance, default: 0.0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
