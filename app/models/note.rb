# coding: UTF-8

class Note < ActiveRecord::Base
  include Attachable
  include Importable

  attr_accessor :doc_file, :music_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true
  delegate :name, :to => :period, :prefix => true, :allow_nil => true

  before_validation(:on => :create){ set_next_item }

  validates_presence_of :item, :title, :count_originals

  after_save :upload

  scope :ordered, :order => 'title ASC'
  scope :preloaded, :include => [:composer, :genre, :period, :languages]

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

  DOCUMENT_TITLE = 'Notearkiv'.freeze

  def self.suggest_voice(search)
    Note.select('distinct voice').where(:voice.matches => search + '%').order('voice').map(&:voice)
  end

  def self.search(search)
    notes = Note.where(:title.matches => '%' + search + '%')
    notes << Composer.where(:name.matches => '%' + search + '%').map(&:notes)
    notes.flatten.uniq.sort{|a,b| a.title <=> b.title}
  end

  def self.excel
    NoteSheet.new(EXCEL_HEADERS,
                  Note.ordered.preloaded,
                  DOCUMENT_TITLE,
                  lambda { |row, item|
                    langs = item.languages.map { |lang| lang.name }

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
                            EXCEL_HEADERS.map { |header| header.title })

    importer.rows.each_with_index do |row, i|
      item = {:sysid => row[0],
              :id => row[1],
              :title => row[2],
              :composer => row[3],
              :genre => row[4],
              :epoch => row[5],
              :languages => import_language_list(row[6]),
              :instrument => row[7],
              :original => row[8],
              :copy => row[9],
              :instrumental => row[10],
              :voice => row[11],
              :solo => row[12],
              :comment => row[13]}

      note = find_existing_if_present(item[:sysid])

      note.import_item(item, i + 2)
    end
  end


  def populate_from_import(item)
    # Mandatory fields
    self.title = item[:title]
    self.count_originals = item[:original]

    # Optional fields - allows overwriting with blank
    self.soloists = item[:solo]
    self.count_copies = item[:copy]
    self.count_instrumental = item[:instrumental]
    self.comment = item[:comment]
    self.voice = item[:voice]
    self.instrument = item[:instrument]

    self.period = item[:epoch].blank? ? nil : Period.find_or_create_by_name(item[:epoch])
    self.composer = item[:composer].blank? ? nil : Composer.find_or_create_by_name(item[:composer])
    self.genre = item[:genre].blank? ? nil : Genre.find_or_create_by_name(item[:genre])

    langs = Array.new
    if (!item[:languages].blank?)
      item[:languages].each do |lang|
        langs << Language.find_or_create_by_name(lang)
      end
    end
    self.languages = langs
  end

  private

  def set_next_item
    self.item = Note.maximum(:item) + 1
  end

  def upload
    self.doc_url = upload_file get_doc_uploader(:note), @doc_file
    self.music_url = upload_file get_music_uploader(:note), @music_file

    # Can't call save - that would recurse. Send a message to the update_without_callbacks method
    self.send(:update_without_callbacks)
  end

  def self.import_language_list(languages)
    languages.blank? ? nil : languages.split(", ")
  end

  def self.find_existing_if_present(id)
    return Note.new if id.blank?

    if (Note.exists? id)
      Note.find(id)
    else
      Note.new
    end
  end
end
