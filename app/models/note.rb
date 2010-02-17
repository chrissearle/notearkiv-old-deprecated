class Note < ActiveRecord::Base
  belongs_to :composer
  belongs_to :genre

  validates_presence_of :item, :title, :voice
end
