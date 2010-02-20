require 'archive/archive'

class Evensong < ActiveRecord::Base
  attr_accessor :pdf_file

  def upload
    archive = Archive.new :evensong_archive

    if @pdf_file && @pdf_file.content_type == "application/pdf"
      url = archive.upload self.id, @pdf_file

      if (url)
        self.url = url

        self.save
      end
    end
  end

  def update_link
    archive = Archive.new :evensong_archive

    url = archive.link_to_file self.id

    if (url)
      self.url = url
    else
      self.url = nil
    end

    self.save
  end

  belongs_to :composer
  belongs_to :genre

  validates_presence_of :title, :composer, :genre
end
