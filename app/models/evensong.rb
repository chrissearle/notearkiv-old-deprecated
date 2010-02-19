require 'dropbox'

class Evensong < ActiveRecord::Base
  attr_accessor :pdf_file

  def upload
    db = DropBox.new(ENV['DROPBOX_USER'],
                     ENV['DROPBOX_PASS'],
                     'Public/Evensong')

    if @pdf_file && @pdf_file.content_type == "application/pdf"
      remove_file

      db.create(@pdf_file.path)
      db.rename(@pdf_file.path.gsub(/.*\//, ''), "evensong_#{self.id}.pdf")

      if (find_file)
        self.url = find_file['url']
        self.save
      end
    end
  end

  def find_file
    db = DropBox.new(ENV['DROPBOX_USER'],
                     ENV['DROPBOX_PASS'],
                     'Public/Evensong')

    return db.list.find {|f| f["name"] == "evensong_#{self.id}.pdf" }
  end

  def remove_file
    db = DropBox.new(ENV['DROPBOX_USER'],
                     ENV['DROPBOX_PASS'],
                     'Public/Evensong')

    file = find_file

    if (file)
      db.destroy "evensong_#{self.id}.pdf"
    end
  end

  belongs_to :composer
  belongs_to :genre
end
