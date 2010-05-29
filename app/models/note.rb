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

  DOCUMENT_TITLE = 'Notearkiv'.freeze

  def self.suggest_voice(search)
    notes = find(:all, :select => 'DISTINCT voice')

    notes.select { |note| note.voice.downcase.start_with? search }.map{ |note| note.voice }
  end


  def upload
    doc_uploader = get_doc_uploader
    music_uploader = get_music_uploader

    url = nil

    if @doc_file.blank?
      url = doc_uploader.find_existing_file self.id
    else
      if doc_uploader.upload_permitted? @doc_file
        url = doc_uploader.upload @doc_file, self.id
      end
    end

    self.doc_url = url

    self.save

    url = nil

    if @music_file.blank?
      url = music_uploader.find_existing_file self.id
    else
      if music_uploader.upload_permitted? @music_file
        url = music_uploader.upload @music_file, self.id
      end
    end

    self.music_url = url

    self.save
  end

  def has_attachment?
    !(doc_url.blank? && music_url.blank?)
  end

  def self.next_item
    Note.maximum(:item) + 1
  end

  def self.find_all_sorted
    Note.find(:all, :include => [:composer, :genre, :period, :languages]).sort_by { |p| p.title.downcase }
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

  def self.import_language_list(languages)
    languages.blank? ? nil : languages.split(", ")
  end

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

end
