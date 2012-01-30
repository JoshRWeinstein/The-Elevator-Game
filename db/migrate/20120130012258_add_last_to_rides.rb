class AddLastToRides < ActiveRecord::Migration
  def change
    add_column :rides, :last, :integer
  end
end
