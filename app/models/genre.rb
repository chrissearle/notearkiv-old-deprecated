class Genre < ActiveRecord::Base
  has_many :notes

  validates_presence_of :name
end
