class ArchiveConnection

  class SupportedFileTypes
    attr_reader :extension, :mimetype, :type

    def initialize(extension, mimetype, type)
      @extension = extension
      @mimetype = mimetype
      @type = type
    end
  end

  class InstanceConnection
    def initialize(session, types, session_type, document_type)
      @instance_session = session
      @instance_types = types.find_all { |t| t.type == document_type }
      @instance_prefix = "Note" if session_type == :note
      @instance_prefix = "Evensong" if session_type == :evensong
    end

    def upload_permitted?(file)
      return file && mimetypes.include?(file.content_type)
    end

    def upload(file, id)
      type = @instance_types.find { |t| t.mimetype == file.content_type }

      @instance_session.upload(file, @instance_prefix)
      @instance_session.rename("#{@instance_prefix}/#{file.original_path}", "#{@instance_prefix}_#{id}.#{type.extension}")

      "#{@instance_prefix}/#{@instance_prefix}_#{id}.#{type.extension}"
    end

    def remove(path)
      @instance_session.delete path
    end

    private

    def mimetypes()
      @instance_types.map { |type| type.mimetype }
    end
  end

  def initialize
    @session = Dropbox::Session.generate_from_token(ENV['DROPBOX_CONSUMER_KEY'],
                                                    ENV['DROPBOX_CONSUMER_SECRET'],
                                                    ENV['DROPBOX_TOKEN'],
                                                    ENV['DROPBOX_TOKEN_SECRET'],
                                                    true)

    @types = [SupportedFileTypes.new("pdf", "application/pdf", :document),
              SupportedFileTypes.new("mp3", "audio/mpeg", :music),
              SupportedFileTypes.new("m4a", "audio/mp4", :music),
              SupportedFileTypes.new("m4a", "audio/x-m4a", :music),
              SupportedFileTypes.new("zip", "application/zip", :document),
              SupportedFileTypes.new("lyd.zip", "application/zip", :music)]
  end

  def get_instance(session_type, document_type)
    InstanceConnection.new(@session, @types, session_type, document_type)
  end
end