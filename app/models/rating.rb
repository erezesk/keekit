class Rating < ActiveRecord::Base
  attr_accessible :advertisement_id, :user_id, :value, :created_at, :updated_at

  belongs_to :advertisement
end
