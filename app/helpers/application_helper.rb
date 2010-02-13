require 'dropbox'

module ApplicationHelper
  def link_to_dropbox_file(object, prefix, check)

    if (object.url.nil? || object.url == "")
      if (check)
        db = DropBox.new(ENV['DROPBOX_USER'],
                         ENV['DROPBOX_PASS'],
                         "Public/#{prefix.capitalize}")

        print "Looking for #{prefix}_#{object.id}.pdf"

        file = db.list.find {|f| f["name"] == "#{prefix}_#{object.id}.pdf" }

        if (file)
          object.url = file['url']

          object.save
        end
      end
    end

    if (object.url)
      s = %{
      <a href="#{object.url}">PDF</a>
      }
    else
      s = "Ikke tilgjengelig"
    end
  end

  def link_to_evensong_file(evensong, check = false)
    link_to_dropbox_file(evensong, "evensong", check)
  end

  def link_to_note_file(note, check = false)
    link_to_dropbox_file(note, "note", check)
  end
end
