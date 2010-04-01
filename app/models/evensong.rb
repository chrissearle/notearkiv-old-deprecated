require 'archive/archive'

require 'excel/header_column'
require 'excel/note_sheet'
require 'excel/importer'


class Evensong < ActiveRecord::Base
  attr_accessor :doc_file, :music_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre

  validates_presence_of :title, :composer, :genre


  EXCEL_HEADERS = [HeaderColumn.new("SysID", 8),
                   HeaderColumn.new("Tittel", 50),
                   HeaderColumn.new("Salme", 8),
                   HeaderColumn.new("Solister", 35),
                   HeaderColumn.new("Komponist", 50),
                   HeaderColumn.new("Genre", 35),
                   HeaderColumn.new("Kommentar", 50)].freeze

  SHEET_TITLE = 'Evensongarkiv'.freeze

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

  def has_attachment?
    !(doc_url.blank? && music_url.blank?)
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
    NoteSheet.new(EXCEL_HEADERS,
                  self.find_all_sorted,
                  SHEET_TITLE,
                  lambda {|row, item|
                    row.push item.id
                    row.push item.title
                    row.push item.psalm
                    row.push item.soloists
                    row.push item.composer ? item.composer.name : ""
                    row.push item.genre ? item.genre.name : ""
                    row.push item.comment
                  })
  end

  def self.import(file)
    importer = Importer.new(file,
                            EXCEL_HEADERS.map { |header| header.title } )

    importer.rows.each do |row|
      item = Hash.new
      item[:sysid] = row[0]
      item[:title] = row[1]
      item[:salme] = row[2]
      item[:solo] = row[3]
      item[:composer] = row[4]
      item[:genre] = row[5]
      item[:comment] = row[6]

      item[:sysid].blank? ? import_create(item) : import_update(item)
    end
  end

  private

  def self.import_create(item)
    evensong = Evensong.new
    populate_from_import(evensong, item)
    if (!evensong.save)
      logger.warn("Unable to create evensong #{evensong.inspect}")
    end
  end

  def self.import_update(item)
    begin
      evensong = Evensong.find(item[:sysid])
    rescue ActiveRecord::RecordNotFound
      evensong = Evensong.new
    end
    populate_from_import(evensong, item)
    if (!evensong.save)
      logger.warn("Unable to update evensong #{evensong.inspect}")
    end
  end

  def self.populate_from_import(evensong, item)
    evensong.title = item[:title] unless item[:title].blank?
    evensong.psalm = item[:salme] unless item[:salme].blank?
    evensong.soloists = item[:solo] unless item[:solo].blank?
    evensong.composer = Composer.find_or_create_by_name(item[:composer]) unless item[:composer].blank?
    evensong.genre = Genre.find_or_create_by_name(item[:genre]) unless item[:genre].blank?
    evensong.comment = item[:comment] unless item[:comment].blank?
  end


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
