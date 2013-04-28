class Advertisement < ActiveRecord::Base
  attr_accessible :name, :active, :views, :ratings_count, :rating, :created_at, 
                  :updated_at, :content_link, :ad_type, :user_id
end
