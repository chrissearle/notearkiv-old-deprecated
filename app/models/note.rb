require 'archive/archive'

class Note < ActiveRecord::Base
  attr_accessor :doc_file

  def upload
    archive = Archive.new :note_archive, :document

    if @doc_file && archive.mimetypes.include?(@doc_file.content_type)
      url = archive.upload self.id, @doc_file

      if (url)
        self.doc_url = url

        self.save
      end
    end
  end

  def update_link
    archive = Archive.new :note_archive, :document

    url = archive.link_to_file self.id

    if (url)
      self.doc_url = url
    else
      self.doc_url = nil
    end

    self.save
  end


  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments
  
  validates_presence_of :item, :title, :count_originals
end
