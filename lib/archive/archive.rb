require 'archive/dropbox'

class Archive
  def initialize(type)

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
    return @db.list.find {|f| f["name"] == "#{@prefix}_#{id}.pdf" }
  end

  def remove_file_if_exists(id)
    file = find_file id

    if (file)
      @db.destroy "#{@prefix}_#{id}.pdf"
    end
  end

  def upload(id, file)
    remove_file_if_exists id

    @db.create(file.path)
    @db.rename(file.path.gsub(/.*\//, ''), "#{@prefix}_#{id}.pdf")

    return link_to_file id
  end


  def link_to_file(id)
    file = find_file id

    if (file = find_file id)
      return file['url']
    end

    return nil
  end
end