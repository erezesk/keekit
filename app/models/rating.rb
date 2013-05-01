# == Schema Information
#
# Table name: ratings
#
#  id               :integer          not null, primary key
#  value            :integer
#  advertisement_id :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Rating < ActiveRecord::Base
  attr_accessible :advertisement_id, :user_id, :value, :created_at, :updated_at

  belongs_to :advertisement
  belongs_to :user
end
