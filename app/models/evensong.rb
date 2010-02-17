class Evensong < ActiveRecord::Base
  belongs_to :composer
  belongs_to :genre
end
