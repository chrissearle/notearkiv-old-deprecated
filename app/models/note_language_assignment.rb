# coding: UTF-8

class NoteLanguageAssignment < ActiveRecord::Base
  belongs_to :note
  belongs_to :language
end
