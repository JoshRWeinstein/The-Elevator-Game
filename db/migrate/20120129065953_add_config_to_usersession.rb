class AddConfigToUsersession < ActiveRecord::Migration
  def change
    add_column :usersessions, :config, :integer
  end
end
