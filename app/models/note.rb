class Note < ActiveRecord::Base
  attr_accessor :doc_file, :music_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments

  validates_presence_of :item, :title, :count_originals

  before_save :set_next_item
  after_save :upload

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
    notes = find(:all, :select => 'DISTINCT voice')

    notes.select { |note| note.voice.downcase.start_with? search }.map { |note| note.voice }
  end

  def has_attachment?
    !(doc_url.blank? && music_url.blank?)
  end

  def self.find_all_sorted
    find(:all, :include => [:composer, :genre, :period, :languages]).sort_by { |p| p.title.downcase }
  end

  def self.excel
    NoteSheet.new(EXCEL_HEADERS,
                  self.find_all_sorted,
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

      item[:sysid].blank? ? import_create(item, i) : import_update(item, i)
    end
  end

  private

  def set_next_item
    if  new_record?
      self.item = Note.maximum(:item) + 1
    end
  end


  def upload
    self.doc_url = upload_file get_doc_uploader, @doc_file
    self.music_url = upload_file get_music_uploader, @music_file

    self.save
  end

  def self.import_language_list(languages)
    languages.blank? ? nil : languages.split(", ")
  end

  def import_item(item, row)
    populate_from_import(item)

    if (!save)
      errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => row)
        import_log.save
      end
    end
  end

  def self.import_create(item, i)
    note = Note.new

    note.import_item(item, i + 2)
  end

  def self.import_update(item, i)
    begin
      note = Note.find(item[:sysid])
    rescue ActiveRecord::RecordNotFound
      note = Note.new
    end

    note.import_item(item, i + 2)
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

  def remove_files
    if (!doc_url.blank?)
      get_archive_connection.remove doc_url
    end

    if (!music_url.blank?)
      get_archive_connection.remove music_url
    end
  end

  def get_archive_connection
    @connection ||= ArchiveConnection.new
  end

  def get_doc_uploader
    @doc_connection ||= get_archive_connection.get_uploader :note, :document
  end

  def get_music_uploader
    @music_connection ||= get_archive_connection.get_uploader :note, :music
  end

  def upload_file(uploader, file)
    url = nil

    if file.blank?
      url = uploader.find_existing_file id
    else
      if uploader.upload_permitted? file
        url = uploader.upload file, id
      end
    end

    return url
  end
end
