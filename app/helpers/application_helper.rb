module ApplicationHelper
  def link_to_dropbox_file(object, type, check)

    if (object.url.nil? || object.url == "")
      if (check)
        object.update_link
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
    link_to_dropbox_file(evensong, :evensong_archive, check)
  end

  def link_to_note_file(note, check = false)
    link_to_dropbox_file(note, :note_file, check)
  end
end
