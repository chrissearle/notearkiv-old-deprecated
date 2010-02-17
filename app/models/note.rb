class Note < ActiveRecord::Base
  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  validates_presence_of :item, :title, :voice
end
