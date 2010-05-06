module ApplicationHelper
  def list_link_dropbox_files(object)
    if (!object.has_attachment?)
      s = "Ikke tilgjengelig"
    else
      s = "<ul>"

      [object.doc_url, object.music_url].each do |url|
        if (!url.blank?)
          prefix = url.gsub /\/[^\/]*$/, ""
          file = url.gsub /.*\//, ""

          s+= content_tag :li do
            link_to get_type(url), download_path(:prefix => prefix, :file => file)

          end
        end
      end

      s+= "</ul>"
    end
  end

  def get_type(url)
    /.*\.(.*)/.match(url)[1].upcase
  end
end
