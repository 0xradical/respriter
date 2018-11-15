class CreatePayments < ActiveRecord::Migration[5.2]
  def change

    execute <<-SQL
      CREATE TYPE payment_source AS ENUM ('impact_radius', 'awin', 'rakuten', 'share_a_sale', 'commission_junction', 'zanox');
      CREATE TYPE payment_status AS ENUM ('open', 'locked', 'paid')
    SQL

    create_table :payments, id: :uuid do |t|
      t.decimal   :sale_amount
      t.decimal   :amount
      t.jsonb     :payload
      t.column    :source, :payment_source
      t.column    :status, :payment_status
      t.timestamps
    end

    add_index :payments, :payload, using: 'gin'
    add_index :payments, :status

  end
end
