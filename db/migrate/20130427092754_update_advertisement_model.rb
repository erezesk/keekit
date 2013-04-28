class UpdateAdvertisementModel < ActiveRecord::Migration
  def up
	add_column :advertisements, :content_link, :string
	remove_column :advertisements, :type
	add_column :advertisements, :ad_type, :string
	change_column :advertisements, :active, :boolean, :default => true
	change_column :advertisements, :rating, :float, :default => 0
	change_column :advertisements, :ratings_count, :integer, :default => 0
	change_column :advertisements, :views, :integer, :default => 0
  end

  def down
	remove_column :advertisements, :content_link
	add_column :advertisements, :type, :string
	remove_column :advertisements, :ad_type
	change_column :advertisements, :active, :boolean
	change_column :advertisements, :rating, :float
	change_column :advertisements, :ratings_count, :integer
	change_column :advertisements, :views, :integer
  end
end
