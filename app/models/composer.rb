# coding: UTF-8

class Composer < ActiveRecord::Base
  has_many :notes
  has_many :evensongs


  validates_presence_of :name
end
