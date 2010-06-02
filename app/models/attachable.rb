module Attachable
  def has_attachment?
    !(doc_url.blank? && music_url.blank?)
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

  def remove_files
    if (!doc_url.blank?)
      get_archive_connection.remove doc_url
    end

    if (!music_url.blank?)
      get_archive_connection.remove music_url
    end
  end

  def get_archive_connection
    ArchiveConnection.new
  end

  def get_doc_uploader(type)
    get_archive_connection.get_uploader type, :document
  end

  def get_music_uploader(type)
    get_archive_connection.get_uploader type, :music
  end

end