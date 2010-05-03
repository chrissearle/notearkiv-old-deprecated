module ApplicationHelper
  def list_link_dropbox_files(object)
    if (!object.has_attachment?)
      s = "Ikke tilgjengelig"
    else
      s = "<ul>"

      if (!object.doc_url.blank?)
        s+= %{
        <li><a href="#{object.doc_url}">#{getType(object.doc_url)}</a></li>
        }
      end

      if (!object.music_url.blank?)
        s+= %{
        <li><a href="#{object.music_url}">#{getType(object.doc_url)}</a></li>
        }
      end

      s+= "</ul>"
    end
  end

  def getType(url)
    /.*\.(.*)/.match(url)[1].upcase
  end
end
