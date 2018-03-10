class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.string :identity_proof_id
      t.string :identity_proof_file
      t.string :account_no
      t.string :account_type
      t.float :account_balance, default: 0.0
      t.references :user

      t.timestamps
    end
  end
end
