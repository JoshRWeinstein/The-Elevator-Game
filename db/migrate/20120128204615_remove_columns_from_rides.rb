class RemoveColumnsFromRides < ActiveRecord::Migration
  def up
    add_column :rides, :top, :boolean
    add_column :rides, :config, :integer
  end

  def down
    remove_column :columns, :rows
  end
end
