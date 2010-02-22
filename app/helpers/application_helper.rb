module ApplicationHelper
  def link_to_dropbox_doc_file(object)
    if (object.doc_url)
      s = %{
      <a href="#{object.doc_url}">PDF</a>
      }
    else
      s = "Ikke tilgjengelig"
    end
  end

  def link_to_dropbox_music_file(object)
    if (object.music_url)
      s = %{
      <a href="#{object.music_url}">MP3/M4A</a>
      }
    else
      s = "Ikke tilgjengelig"
    end
  end
end
