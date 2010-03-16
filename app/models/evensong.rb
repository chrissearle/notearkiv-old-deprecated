require 'archive/archive'

require 'date'

require 'excel/header_column'
require 'excel/note_sheet'


class Evensong < ActiveRecord::Base
  attr_accessor :doc_file, :music_file

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

    archive = Archive.new :evensong_archive, :music

    if @music_file && archive.mimetypes.include?(@music_file.content_type)

      url = archive.upload self.id, @music_file

      if (url)
        self.music_url = url

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

    archive = Archive.new :evensong_archive, :music

    url = archive.link_to_file self.id

    if (url)
      self.music_url = url
    else
      self.music_url = nil
    end

    self.save
  end

  def self.find_all_sorted
    Evensong.find(:all, :include => [:composer, :genre]).sort_by{|p| p.title.downcase}
  end

  def self.excel
    sheet_title = 'Evensongarkiv'
    date_str = Date.today().strftime("%Y-%m-%d")

    NoteSheet.new([HeaderColumn.new("SysID", 8),
                   HeaderColumn.new("Tittel", 50),
                   HeaderColumn.new("Salme", 8),
                   HeaderColumn.new("Solister", 35),
                   HeaderColumn.new("Komponist", 50),
                   HeaderColumn.new("Genre", 35)],
                  Evensong.find_all_sorted,
                  sheet_title,
                  date_str,
                  lambda {|row, item|
                    row.push item.id
                    row.push item.title
                    row.push item.psalm
                    row.push item.soloists
                    row.push item.composer ? item.composer.name : ""
                    row.push item.genre ? item.genre.name : ""
                  })
  end

  private

  def remove_files
    if (!self.doc_url.blank?)
      archive = Archive.new :evensong_archive, :document

      archive.remove_file_if_exists self.id
    end

    if (!self.music_url.blank?)
      archive = Archive.new :evensong_archive, :music

      archive.remove_file_if_exists self.id
    end
  end
end
