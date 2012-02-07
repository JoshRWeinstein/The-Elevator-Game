class ChangeTopToBig < ActiveRecord::Migration
  def up
    rename_column :rides, :top, :big
  end

  def down
  end
end
