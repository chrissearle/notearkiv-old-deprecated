# coding: UTF-8

class Evensong < ActiveRecord::Base
  include Attachable
  include Importable

  attr_accessor :doc_file, :music_file

  before_destroy :remove_files

  belongs_to :composer
  belongs_to :genre

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true

  validates_presence_of :title, :composer, :genre

  after_save :upload

  scope :ordered, :order => 'title ASC'
  scope :preloaded, :include => [:composer, :genre]

  EXCEL_HEADERS = [HeaderColumn.new("SysID", 8),
                   HeaderColumn.new("Tittel", 50),
                   HeaderColumn.new("Salme", 8),
                   HeaderColumn.new("Solister", 35),
                   HeaderColumn.new("Komponist", 50),
                   HeaderColumn.new("Genre", 35),
                   HeaderColumn.new("Kommentar", 50)].freeze

  DOCUMENT_TITLE = 'Evensongarkiv'.freeze

  def self.search(search)
    evensongs = Evensong.where(:title.matches => '%' + search + '%')
    evensongs << Composer.where(:name.matches => '%' + search + '%').map(&:evensongs)
    evensongs.flatten.uniq.sort{|a,b| a.title <=> b.title}
  end

  def self.excel
    NoteSheet.new(EXCEL_HEADERS,
                  Evensong.ordered.preloaded,
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

      evensong = find_existing_if_present(item[:sysid])

      evensong.import_item(item, i + 2)
    end
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

  private

  def self.find_existing_if_present(id)
    return Evensong.new if id.blank?

    if (Evensong.exists? id)
      Evensong.find(id)
    else
      Evensong.new
    end
  end

  def upload
    self.doc_url = upload_file get_doc_uploader(:evensong), @doc_file
    self.music_url = upload_file get_music_uploader(:evensong), @music_file

    # Can't call save - that would recurse. Send a message to the update_without_callbacks method
    self.send(:update_without_callbacks)
  end
end
