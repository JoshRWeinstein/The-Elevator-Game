class AddUpdatedToRides < ActiveRecord::Migration
  def change
    add_column :rides, :updated, :datetime
  end
end
