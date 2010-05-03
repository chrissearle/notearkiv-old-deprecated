class SupportedFileTypes
  attr_reader :extension, :mimetype, :type

  def initialize(extension, mimetype, type)
    @extension = extension
    @mimetype = mimetype
    @type = type
  end
end

class Archive
  def initialize(type, doctype)
    @types = [SupportedFileTypes.new("pdf", "application/pdf", :document),
              SupportedFileTypes.new("mp3", "audio/mpeg", :music),
              SupportedFileTypes.new("m4a", "audio/mp4", :music),
              SupportedFileTypes.new("m4a", "audio/x-m4a", :music),
              SupportedFileTypes.new("zip", "application/zip", :document),
              SupportedFileTypes.new("lyd.zip", "application/zip", :music),
    ]

    @doctype = doctype

    if type == :note_archive
      @prefix = "note"
    end

    if type == :evensong_archive
      @prefix = "evensong"
    end

    @db = DropBox.new(ENV['DROPBOX_USER'],
                      ENV['DROPBOX_PASS'],
                      "Public/#{@prefix.capitalize}")
  end

  def find_file(id)
    Rails.logger.debug "Finding files for ID #{id} for type #{@doctype}"

    possible_filenames = @types.find_all { |t| t.type == @doctype }.map {|t| "#{@prefix}_#{id}.#{t.extension}" }

    Rails.logger.debug possible_filenames.inspect

    file = @db.list.find {|f| possible_filenames.include? f["name"] }

    Rails.logger.debug file

    return file
  end

  def remove_file_if_exists(id)
    file = find_file id

    if (file)
      @db.destroy file["name"]
    end
  end

  def upload(id, file)
    remove_file_if_exists id

    type = @types.find { |t| t.mimetype == file.content_type && t.type == @doctype }

    @db.create(file.path)
    @db.rename(file.path.gsub(/.*\//, ''), "#{@prefix}_#{id}.#{type.extension}")

    return link_to_file id
  end


  def link_to_file(id)
    file = find_file id

    if (file = find_file id)
      return file['url']
    end

    return nil
  end

  def mimetypes
    return @types.find_all{ |t| t.type == @doctype}.map { |type| type.mimetype }
  end

  def stats
    @db.usage_stats
  end
end