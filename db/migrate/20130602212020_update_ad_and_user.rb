class UpdateAdAndUser < ActiveRecord::Migration
  def up
  	rename_column :advertisements, :views, :shares
  	rename_column :users, :country, :gender
  end

  def down
  	rename_column :advertisements, :shares, :views
  	rename_column :users, :gender, :country
  end
end
