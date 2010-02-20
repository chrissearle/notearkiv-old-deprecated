module ApplicationHelper
  def link_to_dropbox_file(object)
    if (object.url)
      s = %{
      <a href="#{object.url}">PDF</a>
      }
    else
      s = "Ikke tilgjengelig"
    end
  end
end
