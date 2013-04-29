class User < ActiveRecord::Base
  attr_accessible :birthday, :country, :email, :type, :username
end
