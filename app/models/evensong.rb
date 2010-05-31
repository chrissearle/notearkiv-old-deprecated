class Evensong < ActiveRecord::Base
  attr_accessor :doc_file, :music_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre

  validates_presence_of :title, :composer, :genre

  after_save :upload

  EXCEL_HEADERS = [HeaderColumn.new("SysID", 8),
                   HeaderColumn.new("Tittel", 50),
                   HeaderColumn.new("Salme", 8),
                   HeaderColumn.new("Solister", 35),
                   HeaderColumn.new("Komponist", 50),
                   HeaderColumn.new("Genre", 35),
                   HeaderColumn.new("Kommentar", 50)].freeze

  DOCUMENT_TITLE = 'Evensongarkiv'.freeze

  def has_attachment?
    !(doc_url.blank? && music_url.blank?)
  end

  def self.find_all_sorted
    find(:all, :include => [:composer, :genre]).sort_by { |p| p.title.downcase }
  end

  def self.excel
    NoteSheet.new(EXCEL_HEADERS,
                  find_all_sorted,
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
      item = {:sysid => row[0],
              :title => row[1],
              :salme => row[2],
              :solo => row[3],
              :composer => row[4],
              :genre => row[5],
              :comment => row[6]}

      item[:sysid].blank? ? import_create(item, i) : import_update(item, i)
    end
  end

  private

  def upload
    self.doc_url = upload_file get_doc_uploader, @doc_file
    self.music_url = upload_file get_music_uploader, @music_file

    # Can't call save - that would recurse. Send a message to the update_without_callbacks method
    self.send(:update_without_callbacks)
  end

  def self.import_create(item, i)
    evensong = Evensong.new

    evensong.import_item(item, i + 2)
  end

  def self.import_update(item, i)
    begin
      evensong = Evensong.find(item[:sysid])
    rescue ActiveRecord::RecordNotFound
      evensong = Evensong.new
    end

    evensong.import_item(item, i + 2)
  end

  def import_item(item, row)
    # Mandatory fields
    self.title = item[:title]
    self.composer = item[:composer].blank? ? nil : Composer.find_or_create_by_name(item[:composer])
    self.genre = item[:genre].blank? ? nil : Genre.find_or_create_by_name(item[:genre])

    # Optional fields - allows overwriting with empty
    self.psalm = item[:salme]
    self.soloists = item[:solo]
    self.comment = item[:comment]

    if (!save)
      errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => row)
        import_log.save
      end
    end
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
