# coding: UTF-8

class Language < ActiveRecord::Base
  has_many :note_language_assignments
  has_many :notes, :through => :note_language_assignments

 validates_presence_of :name
end
