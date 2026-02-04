class ChangeStatusToInvoice < ActiveRecord::Migration[8.0]
  def change
    change_column :invoices, :status, :string
  end
end
