class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :usersessions, :rides, :ridecount
  end

  def down
  end
end
