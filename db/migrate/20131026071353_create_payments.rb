class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|

    	t.string :sid
    	t.integer :bitcent_id
    	t.integer :amount
    	t.boolean :is_paid
    	t.string :error
    	t.string :from
    	t.string :ip_addr

      t.timestamps
    end
  end
end
