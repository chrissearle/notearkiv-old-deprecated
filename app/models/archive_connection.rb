# coding: UTF-8

class ArchiveConnection
  extend ActiveModel::Naming

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
      Rails.logger.info "Upload test for #{file.original_path} with type #{file.content_type}" unless file.blank?

      return !file.blank? && mimetypes.include?(file.content_type)
    end

    def upload(file, id)
      remove_existing_files(id)

      type = @instance_types.find { |t| t.mimetype == file.content_type }

      @instance_session.upload(file, "#{@instance_prefix}/#{@instance_type_prefix}")

      @instance_session.rename("#{@instance_prefix}/#{@instance_type_prefix}/#{file.original_path}", item_path(id, type))

      fullpath = full_path(id, type)

      Rails.logger.info("Uploaded #{fullpath}")

      fullpath
    end

    def find_existing_file(id)
      match_filename = "#{@instance_type_prefix}/#{@instance_prefix}_#{id}".downcase

      Rails.logger.info("Searching for existing files for #{id} with a match of #{match_filename}")

      files = @instance_session.list "#{@instance_prefix}/#{@instance_type_prefix}"

      files.each do |file|
        Rails.logger.info("Saw #{file.path.downcase}")
      end

      file = files.select { |file| file.path.downcase.include? match_filename }[0]

      unless file.blank?
        Rails.logger.info("Selected #{file.path}")
        file = file.path.gsub(/^\//, "")
      end

      file
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
    @session = Dropbox::Session.deserialize(session_cache = SessionCache.find(1).serialized_session)

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

  def stats
    stats = @session.account

    {:normal => stats[:quota_info][:normal] / (1024.0*1024.0),
     :shared => stats[:quota_info][:shared] / (1024.0*1024.0),
     :max => stats[:quota_info][:quota] / (1024.0*1024.0),
     :account => stats[:display_name],
     :id => stats[:uid]}
  end
end

3758096384