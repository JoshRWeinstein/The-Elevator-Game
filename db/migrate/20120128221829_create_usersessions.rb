class CreateUsersessions < ActiveRecord::Migration
  def change
    create_table :usersessions do |t|
      t.integer :rides
      t.integer :floors
      t.float :time

      t.timestamps
    end
  end
end
