class UserType < ActiveRecord::Base
  validates_presence_of     :name
  validates_length_of       :name,    :within => 3..255

  has_many :users
end
