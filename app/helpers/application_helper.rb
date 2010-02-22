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
end
