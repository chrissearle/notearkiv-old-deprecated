require 'archive/archive'

require 'excel/header_column'
require 'excel/note_sheet'
require 'excel/importer'


class Note < ActiveRecord::Base
  attr_accessor :doc_file, :music_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments

  validates_presence_of :item, :title, :count_originals

  EXCEL_HEADERS = [HeaderColumn.new("SysID", 8),
                   HeaderColumn.new("ID", 8),
                   HeaderColumn.new("Tittel", 50),
                   HeaderColumn.new("Komponist", 35),
                   HeaderColumn.new("Genre", 35),
                   HeaderColumn.new("Epoke", 35),
                   HeaderColumn.new("Språk", 35),
                   HeaderColumn.new("Akkomp.", 35),
                   HeaderColumn.new("Original", 8),
                   HeaderColumn.new("Kopi", 8),
                   HeaderColumn.new("Instr.", 8),
                   HeaderColumn.new("Besetning", 15),
                   HeaderColumn.new("Solister", 35),
                   HeaderColumn.new("Kommentar", 50)].freeze

  SHEET_TITLE = 'Notearkiv'.freeze

  def upload
    archive = Archive.new :note_archive, :document

    if @doc_file && archive.mimetypes.include?(@doc_file.content_type)
      url = archive.upload self.id, @doc_file

      if (url)
        self.doc_url = url

        self.save
      end
    end

    archive = Archive.new :note_archive, :music

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
    archive = Archive.new :note_archive, :document

    url = archive.link_to_file self.id

    if (url)
      self.doc_url = url
    else
      self.doc_url = nil
    end

    archive = Archive.new :note_archive, :music

    url = archive.link_to_file self.id

    if (url)
      self.music_url = url
    else
      self.music_url = nil
    end

    self.save
  end

  def self.next_item
    Note.maximum(:item) + 1
  end

  def self.find_all_sorted
    Note.find(:all, :include => [:composer, :genre, :period, :languages]).sort_by{|p| p.title.downcase}
  end

  def self.excel

    NoteSheet.new(EXCEL_HEADERS,
                  self.find_all_sorted,
                  SHEET_TITLE,
                  lambda {|row, item|
                    langs = item.languages.map{|lang| lang.name }

                    row.push item.id
                    row.push item.item
                    row.push item.title
                    row.push item.composer ? item.composer.name : ""
                    row.push item.genre ? item.genre.name : ""
                    row.push item.period ? item.period.name : ""
                    row.push langs.join(", ")
                    row.push item.instrument
                    row.push item.count_originals
                    row.push item.count_copies
                    row.push item.count_instrumental
                    row.push item.voice
                    row.push item.soloists
                    row.push item.comment
                  })
  end

  def self.import(file)
    ImportLog.delete_all

    importer = Importer.new(file,
                            EXCEL_HEADERS.map { |header| header.title } )

    importer.rows.each_with_index do |row, i|
      item = Hash.new
      item[:sysid] = row[0]
      item[:id] = row[1]
      item[:title] = row[2]
      item[:composer] = row[3]
      item[:genre] = row[4]
      item[:epoch] = row[5]
      item[:languages] = row[6].blank? ? nil : row[6].split(", ")
      item[:instrument] = row[7]
      item[:original] = row[8]
      item[:copy] = row[9]
      item[:instrumental] = row[10]
      item[:voice] = row[11]
      item[:solo] = row[12]
      item[:comment] = row[13]

      item[:sysid].blank? ? import_create(item, i) : import_update(item, i)
    end
  end

  private

  def self.import_create(item, i)
    note = Note.new
    note.item = Note.next_item
    populate_from_import(note, item)
    if (!note.save)
      note.errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => i + 2)
        import_log.save
      end
    end
  end

  def self.import_update(item, i)
    begin
      note = Note.find(item[:sysid])
    rescue ActiveRecord::RecordNotFound
      note = Note.new
      note.item = Note.next_item
    end
    populate_from_import(note, item)
    if (!note.save)
      note.errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => i + 2)
        import_log.save
      end
    end
  end

  def self.populate_from_import(note, item)
    # Mandatory fields
    note.title = item[:title]
    note.count_originals = item[:original]

    # Optional fields - allows overwriting with blank
    note.soloists = item[:solo]
    note.count_copies = item[:copy]
    note.count_instrumental = item[:instrumental]
    note.comment = item[:comment]
    note.voice = item[:voice]
    note.instrument = item[:instrument]

    note.period = item[:epoch].blank? ? nil : Period.find_or_create_by_name(item[:epoch])
    note.composer = item[:composer].blank? ? nil : Composer.find_or_create_by_name(item[:composer])
    note.genre = item[:genre].blank? ? nil : Genre.find_or_create_by_name(item[:genre])

    langs = Array.new
    if (!item[:languages].blank?)
      item[:languages].each do |lang|
        langs << Language.find_or_create_by_name(lang)
      end
    end
    note.languages = langs
  end

  def remove_files
    if (!self.doc_url.blank?)
      archive = Archive.new :note_archive, :document

      archive.remove_file_if_exists self.id
    end

    if (!self.music_url.blank?)
      archive = Archive.new :note_archive, :music

      archive.remove_file_if_exists self.id
    end
  end
end
