class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :name
      t.string :type
      t.boolean :active
      t.integer :views
      t.integer :ratings_count
      t.float :rating

      t.timestamps
    end
  end
end
