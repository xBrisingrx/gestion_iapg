class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :number, null: false
      t.references :company, null: false, foreign_key: true
      t.integer :status
      t.string :detail
      t.date :date
      t.date :pay_date
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
