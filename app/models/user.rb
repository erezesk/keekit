# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string(255)
#  email             :string(255)
#  type              :string(255)
#  birthday          :datetime
#  country           :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :birthday, :country, :email, :user_type, :username
  attr_accessible :password, :password_confirmation

  acts_as_authentic

  has_many :advertisements, :dependent => :destroy
  has_many :ratings, :dependent => :destroy
end
