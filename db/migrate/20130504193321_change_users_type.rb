class ChangeUsersType < ActiveRecord::Migration
  def up
  	remove_column :users, :type
	add_column :users, :user_type, :string
  end

  def down
  	add_column :users, :type, :string
	remove_column :users, :user_type
  end
end
