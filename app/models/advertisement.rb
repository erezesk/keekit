class Advertisement < ActiveRecord::Base
  attr_accessible :active, :name, :rating, :ratings_count, :type, :views
end
