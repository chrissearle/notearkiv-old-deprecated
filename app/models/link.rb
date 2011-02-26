class Link < ActiveRecord::Base
  belongs_to :note
  belongs_to :evensong

  validates_presence_of :title, :url
end
