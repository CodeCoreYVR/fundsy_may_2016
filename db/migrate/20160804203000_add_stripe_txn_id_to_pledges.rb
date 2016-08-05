class AddStripeTxnIdToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :stripe_txn_id, :string
  end
end
