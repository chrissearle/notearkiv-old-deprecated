require 'archive/archive'

class Note < ActiveRecord::Base
  attr_accessor :pdf_file

  def upload
    archive = Archive.new :note_archive

    if @pdf_file && @pdf_file.content_type == "application/pdf"
      url = archive.upload self.id, @pdf_file

      if (url)
        self.url = url

        self.save
      end
    end
  end

  def update_link
    archive = Archive.new :note_archive

    url = archive.link_to_file self.id

    if (url)
      self.url = url

      self.save
    end
  end


  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments
  
  validates_presence_of :item, :title, :count_originals
end
