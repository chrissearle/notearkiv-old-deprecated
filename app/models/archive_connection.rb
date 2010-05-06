class ArchiveConnection

  class SupportedFileTypes
    attr_reader :extension, :mimetype, :type, :disposition

    def initialize(extension, mimetype, type, disposition)
      @extension = extension
      @mimetype = mimetype
      @type = type
      @disposition = disposition
    end
  end

  class InstanceConnection
    def initialize(session, types, session_type, document_type)
      @instance_session = session
      @instance_types = types.find_all { |t| t.type == document_type }
      @instance_prefix = "Note" if session_type == :note
      @instance_prefix = "Evensong" if session_type == :evensong
      @instance_type_prefix = "D" if document_type == :document
      @instance_type_prefix = "L" if document_type == :music
    end

    def upload_permitted?(file)
      return file && mimetypes.include?(file.content_type)
    end

    def upload(file, id)
      remove_existing_files(id)

      type = @instance_types.find { |t| t.mimetype == file.content_type }

      @instance_session.upload(file, "#{@instance_prefix}/#{@instance_type_prefix}")
      
      @instance_session.rename("#{@instance_prefix}/#{@instance_type_prefix}/#{file.original_path}", item_path(id, type))

      full_path(id, type)
    end

    private

    def item_path(id, type)
      "#{@instance_prefix}_#{id}.#{type.extension}"
    end

    def full_path(id, type)
      "#{@instance_prefix}/#{@instance_type_prefix}/#{item_path(id, type)}"
    end

    def mimetypes()
      @instance_types.map { |type| type.mimetype }
    end

    def remove_existing_files(id)
      @instance_types.map do |type|
        begin
          @instance_session.delete full_path(id, type)
        rescue Dropbox::FileNotFoundError
          # Do nothing - the file is not present
        end
      end
    end
  end

  def initialize
    @session = Dropbox::Session.generate_from_token(ENV['DROPBOX_CONSUMER_KEY'],
                                                    ENV['DROPBOX_CONSUMER_SECRET'],
                                                    ENV['DROPBOX_TOKEN'],
                                                    ENV['DROPBOX_TOKEN_SECRET'],
                                                    true)

    @types = [SupportedFileTypes.new("pdf", "application/pdf", :document, "inline"),
              SupportedFileTypes.new("mp3", "audio/mpeg", :music, "attachment"),
              SupportedFileTypes.new("m4a", "audio/mp4", :music, "attachment"),
              SupportedFileTypes.new("m4a", "audio/x-m4a", :music, "attachment"),
              SupportedFileTypes.new("zip", "application/zip", :document, "attachment"),
              SupportedFileTypes.new("zip", "application/zip", :music, "attachment")]
  end

  def get_uploader(session_type, document_type)
    InstanceConnection.new(@session, @types, session_type, document_type)
  end

  def remove(path)
    @session.delete path
  end

  def download(path)
    @session.download(path)
  end

  def mimetype_for_path(path)
    @types.find { |t| t.extension == path.split(".").last }.mimetype
  end

  def disposition_for_path(path)
    @types.find { |t| t.extension == path.split(".").last }.disposition
  end
end