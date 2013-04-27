class Advertisement < ActiveRecord::Base
  attr_accessible :active, :name, :rating, :ratings_count, :ad_type, :views, :content_link
end
