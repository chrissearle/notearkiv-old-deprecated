class Note < ActiveRecord::Base
  belongs_to :composer

  validates_presence_of :item, :title, :voice
end
