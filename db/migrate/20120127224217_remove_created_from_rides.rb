class RemoveCreatedFromRides < ActiveRecord::Migration
  def up
    remove_column :rides, :created
  end

  def down
    add_column :rides, :created, :datetime
  end
end
