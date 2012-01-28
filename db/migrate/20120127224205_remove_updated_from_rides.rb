class RemoveUpdatedFromRides < ActiveRecord::Migration
  def up
    remove_column :rides, :updated
  end

  def down
    add_column :rides, :updated, :datetime
  end
end
