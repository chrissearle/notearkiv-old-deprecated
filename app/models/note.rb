class Note < ActiveRecord::Base
  has_and_belongs_to_many :composers
  has_and_belongs_to_many :genres
  
end
