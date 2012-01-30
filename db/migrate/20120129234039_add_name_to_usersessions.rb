class AddNameToUsersessions < ActiveRecord::Migration
  def change
    add_column :usersessions, :name, :string
  end
end
