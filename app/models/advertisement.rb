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

class Advertisement < ActiveRecord::Base
  attr_accessible :name, :active, :views, :ratings_count, :rating, :created_at, 
                  :updated_at, :content_link, :ad_type, :user_id

  validates :name,  :presence => true
  validates :content_link,  :presence => true

  has_many   :ratings, :dependent => :destroy
  belongs_to :user

  scope :only_active, where(active: true)
  scope :by_user, lambda{ |user| where(user_id: user.id) unless user.nil? }
  scope :not_by_user, lambda{ |user| where("user_id != #{user.id}") unless user.nil? }

  scope :not_rated_by_user, lambda { |user| where("id not in(#{(Rating.rated_ads_by_user(user).collect(&:advertisement_id)<<0).join(',')})") unless user.nil? }
  scope :for_homepage, lambda { |user| only_active.not_by_user(user).not_rated_by_user(user) }
  scope :my_ads, lambda { |user| by_user(user) }
  scope :my_rated_ads, lambda { |user| where(:id => Rating.rated_ads_by_user(user).collect(&:advertisement_id)) unless user.nil? }

  def user_rating(user_id) 
    Rating.where(user_id: user_id, advertisement_id: id).first
  end
end
