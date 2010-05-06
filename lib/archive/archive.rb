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
  end

  def find_file(id)
  end

  def remove_file_if_exists(id)
  end

  def upload(id, file)
  end


  def link_to_file(id)
  end

  def mimetypes
    return @types.find_all{ |t| t.type == @doctype}.map { |type| type.mimetype }
  end

  def stats
  end
end