class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :ip_address
      t.integer :session_id
      t.float :timetoclick
      t.integer :rows
      t.integer :columns
      t.integer :floor
      t.datetime :created

      t.timestamps
    end
  end
end
