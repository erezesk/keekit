class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value
      t.references :advertisement
      t.integer :user_id

      t.timestamps
    end
  end
end
