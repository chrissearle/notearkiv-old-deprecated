# coding: UTF-8

class Period < ActiveRecord::Base
  has_many :notes

  validates_presence_of :name
end
