class CreateBitcents < ActiveRecord::Migration
  def change
    create_table :bitcents do |t|
    	t.integer :x
    	t.integer :y
    	t.integer :width
    	t.integer :height
    	t.string :title
    	t.string :link
    	t.integer :image_id

      t.timestamps
    end
  end

end
