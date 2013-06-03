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
  attr_accessible :name, :active, :shares, :ratings_count, :rating, :created_at, 
                  :updated_at, :content_link, :ad_type, :user_id

  validates :name,  :presence => true
  validates :content_link,  :presence => true

  has_many   :ratings, :dependent => :destroy
  belongs_to :user

  scope :only_active, where(active: true)
  scope :by_user, lambda{ |user| where(user_id: user.id) unless user.nil? }
  scope :not_by_user, lambda{ |user| where("user_id != #{user.id}") unless user.nil? }
  scope :excluding_ids, lambda { |ids| where("id not in(#{ids.join(',')})") unless ids.blank? }  
  scope :not_rated_by_user, lambda { |user| where("id not in(#{(Rating.rated_ads_by_user(user).collect(&:advertisement_id)<<0).join(',')})") unless user.nil? }
  scope :by_id_desc, order("advertisements.id desc")

  scope :for_homepage, lambda { |user| only_active.not_by_user(user).not_rated_by_user(user) }
  scope :my_ads, lambda { |user| by_user(user).by_id_desc }
  scope :my_rated_ads, lambda { |user| where(:id => Rating.rated_ads_by_user(user).collect(&:advertisement_id)).most_popular unless user.nil? }
  scope :most_popular, only_active.order("rating desc")

  def user_rating(user_id) 
    Rating.where(user_id: user_id, advertisement_id: id).first
  end

  def average_rating_by_gender
    male_count = 0.0
    female_count = 0.0
    male_total = 0.0
    female_total = 0.0

    Rating.where(advertisement_id: id).select("user_id, value").each do |current_rating|
      if current_rating.user.gender == "Male"
        male_count += 1
        male_total += current_rating.value
      elsif current_rating.user.gender == "Female"
        female_count += 1
        female_total += current_rating.value
      end
    end

    {male_average: (male_count == 0) ? 0 : male_total / male_count, female_average: (female_count == 0) ? 0 : female_total / female_count}
  end
end
