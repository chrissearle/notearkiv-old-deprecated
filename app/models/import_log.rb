# coding: UTF-8

class ImportLog < ActiveRecord::Base
  scope :ordered, :order => 'item ASC, created_at ASC'
end
