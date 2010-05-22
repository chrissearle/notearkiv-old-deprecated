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

  DOCUMENT_TITLE = 'Evensongarkiv'.freeze

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

  def self.find_all_sorted
    Evensong.find(:all, :include => [:composer, :genre]).sort_by { |p| p.title.downcase }
  end

  def self.excel
    NoteSheet.new(EXCEL_HEADERS,
                  self.find_all_sorted,
                  DOCUMENT_TITLE,
                  lambda { |row, item|
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
    ImportLog.delete_all

    importer = Importer.new(file,
                            EXCEL_HEADERS.map { |header| header.title })

    importer.rows.each_with_index do |row, i|
      item = Hash.new
      item[:sysid] = row[0]
      item[:title] = row[1]
      item[:salme] = row[2]
      item[:solo] = row[3]
      item[:composer] = row[4]
      item[:genre] = row[5]
      item[:comment] = row[6]

      item[:sysid].blank? ? import_create(item, i) : import_update(item, i)
    end
  end

  private

  def self.import_create(item, i)
    evensong = Evensong.new
    populate_from_import(evensong, item)
    if (!evensong.save)
      evensong.errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => i + 2)
        import_log.save
      end
    end
  end

  def self.import_update(item, i)
    begin
      evensong = Evensong.find(item[:sysid])
    rescue ActiveRecord::RecordNotFound
      evensong = Evensong.new
    end
    populate_from_import(evensong, item)
    if (!evensong.save)
      evensong.errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => i + 2)
        import_log.save
      end
    end
  end

  def self.populate_from_import(evensong, item)
    # Mandatory fields
    evensong.title = item[:title]
    evensong.composer = item[:composer].blank? ? nil : Composer.find_or_create_by_name(item[:composer])
    evensong.genre = item[:genre].blank? ? nil : Genre.find_or_create_by_name(item[:genre])

    # Optional fields - allows overwriting with empty
    evensong.psalm = item[:salme]
    evensong.soloists = item[:solo]
    evensong.comment = item[:comment]
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
    @doc_connection ||= get_archive_connection.get_uploader :evensong, :document
  end

  def get_music_uploader
    @music_connection ||= get_archive_connection.get_uploader :evensong, :music
  end
end
