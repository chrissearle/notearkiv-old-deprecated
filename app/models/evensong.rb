require 'archive/archive'

class Evensong < ActiveRecord::Base
  attr_accessor :doc_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre

  validates_presence_of :title, :composer, :genre

  def upload
    archive = Archive.new :evensong_archive, :document

    if @doc_file && archive.mimetypes.include?(@doc_file.content_type)
      url = archive.upload self.id, @doc_file

      if (url)
        self.doc_url = url

        self.save
      end
    end
  end

  def update_link
    archive = Archive.new :evensong_archive, :document

    url = archive.link_to_file self.id

    if (url)
      self.doc_url = url
    else
      self.doc_url = nil
    end

    self.save
  end

  private

  def remove_files
    if (!self.doc_url.blank?)
      archive = Archive.new :evensong_archive, :document

      archive.remove_file_if_exists self.id
    end
  end
end
