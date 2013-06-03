class ChangeUserBirthdayToDate < ActiveRecord::Migration
 def self.up
   change_column :users, :birthday, :date
  end

  def self.down
   change_column :users, :birthday, :datetime
  end
end
