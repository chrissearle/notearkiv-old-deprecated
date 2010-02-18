class Note < ActiveRecord::Base
  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments
  
  validates_presence_of :item, :title, :voice
end
