# == Schema Information
#
# Table name: advertisements
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  active        :boolean          default(TRUE)
#  shares        :integer          default(0)
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

  def average_rating_by_age_and_gender
    male_count = { u13: 0.0, u17: 0.0, u25: 0.0, u35: 0.0, u45: 0.0, u60: 0.0, o60: 0.0 }
    female_count = { u13: 0.0, u17: 0.0, u25: 0.0, u35: 0.0, u45: 0.0, u60: 0.0, o60: 0.0 }
    general_count = { u13: 0.0, u17: 0.0, u25: 0.0, u35: 0.0, u45: 0.0, u60: 0.0, o60: 0.0 }
    male_total = { u13: 0.0, u17: 0.0, u25: 0.0, u35: 0.0, u45: 0.0, u60: 0.0, o60: 0.0 }
    female_total = { u13: 0.0, u17: 0.0, u25: 0.0, u35: 0.0, u45: 0.0, u60: 0.0, o60: 0.0 }
    general_total = { u13: 0.0, u17: 0.0, u25: 0.0, u35: 0.0, u45: 0.0, u60: 0.0, o60: 0.0 }

    Rating.where(advertisement_id: id).select("user_id, value").each do |current_rating|
      if current_rating.user.gender == "Male"
        count_hash = male_count
        total_hash = male_total
      elsif current_rating.user.gender == "Female"
        count_hash = female_count
        total_hash = female_total
      end

      case current_rating.user.age
        when 0..13
          age_report_helper(general_count, general_total, count_hash, total_hash, :u13, current_rating.value)
        when 14..17
          age_report_helper(general_count, general_total, count_hash, total_hash, :u17, current_rating.value)
        when 18..25
          age_report_helper(general_count, general_total, count_hash, total_hash, :u25, current_rating.value)
        when 26..35
          age_report_helper(general_count, general_total, count_hash, total_hash, :u35, current_rating.value)
        when 36..45
          age_report_helper(general_count, general_total, count_hash, total_hash, :u45, current_rating.value)
        when 46..60
          age_report_helper(general_count, general_total, count_hash, total_hash, :u60, current_rating.value)
        else
          age_report_helper(general_count, general_total, count_hash, total_hash, :o60, current_rating.value)
      end
    end

    male_average = {  u13: (male_count[:u13] == 0) ? 0 : male_total[:u13] / male_count[:u13],
                      u17: (male_count[:u17] == 0) ? 0 : male_total[:u17] / male_count[:u17],
                      u25: (male_count[:u25] == 0) ? 0 : male_total[:u25] / male_count[:u25],
                      u35: (male_count[:u35] == 0) ? 0 : male_total[:u35] / male_count[:u35],
                      u45: (male_count[:u45] == 0) ? 0 : male_total[:u45] / male_count[:u45],
                      u60: (male_count[:u60] == 0) ? 0 : male_total[:u60] / male_count[:u60],
                      o60: (male_count[:o60] == 0) ? 0 : male_total[:o60] / male_count[:o60]
                   }

    female_average =  { u13: (female_count[:u13] == 0) ? 0 : female_total[:u13] / female_count[:u13],
                        u17: (female_count[:u17] == 0) ? 0 : female_total[:u17] / female_count[:u17],
                        u25: (female_count[:u25] == 0) ? 0 : female_total[:u25] / female_count[:u25],
                        u35: (female_count[:u35] == 0) ? 0 : female_total[:u35] / female_count[:u35],
                        u45: (female_count[:u45] == 0) ? 0 : female_total[:u45] / female_count[:u45],
                        u60: (female_count[:u60] == 0) ? 0 : female_total[:u60] / female_count[:u60],
                        o60: (female_count[:o60] == 0) ? 0 : female_total[:o60] / female_count[:o60]
                      }

    general_average =  {  u13: (general_count[:u13] == 0) ? 0 : general_total[:u13] / general_count[:u13],
                          u17: (general_count[:u17] == 0) ? 0 : general_total[:u17] / general_count[:u17],
                          u25: (general_count[:u25] == 0) ? 0 : general_total[:u25] / general_count[:u25],
                          u35: (general_count[:u35] == 0) ? 0 : general_total[:u35] / general_count[:u35],
                          u45: (general_count[:u45] == 0) ? 0 : general_total[:u45] / general_count[:u45],
                          u60: (general_count[:u60] == 0) ? 0 : general_total[:u60] / general_count[:u60],
                          o60: (general_count[:o60] == 0) ? 0 : general_total[:o60] / general_count[:o60]
                       }

    { u13: { male: male_average[:u13], female: female_average[:u13], total: general_average[:u13] },
      u17: { male: male_average[:u17], female: female_average[:u17], total: general_average[:u17] },
      u25: { male: male_average[:u25], female: female_average[:u25], total: general_average[:u25] },
      u35: { male: male_average[:u35], female: female_average[:u35], total: general_average[:u35] },
      u45: { male: male_average[:u45], female: female_average[:u45], total: general_average[:u45] },
      u60: { male: male_average[:u60], female: female_average[:u60], total: general_average[:u60] },
      o60: { male: male_average[:o60], female: female_average[:o60], total: general_average[:o60] }
    }
  end

  private
  
  def age_report_helper(general_count, general_total, current_count, current_total, age_symbol, rating_value)
    general_count[age_symbol] += 1
    current_count[age_symbol] += 1
    general_total[age_symbol] += rating_value
    current_total[age_symbol] += rating_value
  end
end
