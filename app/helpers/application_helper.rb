module ApplicationHelper
  def list_link_dropbox_files(object)
    if (!object.has_attachment?)
      s = "Ikke tilgjengelig"
    else
      s = "<ul>"

      if (!object.doc_url.blank?)
        s+= %{
        <li><a href="#{object.doc_url}">PDF</a></li>
        }
      end

      if (!object.music_url.blank?)
        s+= %{
        <li><a href="#{object.music_url}">MP3/M4A</a></li>
        }
      end

      s+= "</ul>"
    end
  end
end
