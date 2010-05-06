module ApplicationHelper
  def list_link_dropbox_files(object)
    if (!object.has_attachment?)
      s = "Ikke tilgjengelig"
    else
      if permitted_to? :download, :archive
        s = "<ul>"

        [object.doc_url, object.music_url].each do |url|
          if (!url.blank?)
            s+= content_tag :li do
              content_tag :a, :href => "/download/#{url}" do
                get_type(url)
              end
            end
          end
        end

        s+= "</ul>"
      end
    end
  end

  def get_type(url)
    /.*\.(.*)/.match(url)[1].upcase
  end
end
