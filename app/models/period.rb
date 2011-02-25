# coding: UTF-8

class Period < ActiveRecord::Base
  has_many :notes

  validates_presence_of :name

  scope :ordered, :order => 'name ASC'
  scope :preloaded, :include => [:notes]
end
