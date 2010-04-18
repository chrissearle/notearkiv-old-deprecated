require 'archive'
require 'excel'
require 'pdf'

require 'iconv'

class String
  def to_latin1
    Iconv.iconv("LATIN1", "UTF-8", self)
  end
end

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

  PDF_HEADERS = [PDFCol.new("Tittel"),
                 PDFCol.new("Salme"),
                 PDFCol.new("Komponist"),
                 PDFCol.new("Genre")].freeze


  DOCUMENT_TITLE = 'Evensongarkiv'.freeze

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
                  DOCUMENT_TITLE,
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

  def self.pdf
    data = self.find_all_sorted.map do |item|
      Hash['Tittel' => item.title.to_latin1,
              'Komponist' => item.composer ? item.composer.name.to_latin1 : "",
              'Salme' => item.psalm,
              'Genre' => item.genre ? item.genre.name.to_latin1 : ""
      ]
    end

    PDFDoc.new(data,
               DOCUMENT_TITLE,
               PDF_HEADERS)
  end

  def self.import(file)
    ImportLog.delete_all

    importer = Importer.new(file,
                            EXCEL_HEADERS.map { |header| header.title } )

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
