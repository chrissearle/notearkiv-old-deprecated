# coding: UTF-8

class Composer < ActiveRecord::Base
  has_many :notes
  has_many :evensongs

  validates_presence_of :name

  def deletable?
    notes.size() == 0 && evensongs.size() == 0
  end
end
