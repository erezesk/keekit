# == Schema Information
#
# Table name: advertisements
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  active        :boolean          default(TRUE)
#  views         :integer          default(0)
#  ratings_count :integer          default(0)
#  rating        :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  content_link  :string(255)
#  ad_type       :string(255)
#  user_id       :integer
#

require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
