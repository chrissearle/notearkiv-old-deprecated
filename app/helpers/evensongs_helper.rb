require 'dropbox'

module EvensongsHelper
  def link_to_evensong_file(evensong, check = false)

    if (evensong.url.nil? || evensong.url == "")
      if (check)
        db = DropBox.new(ENV['DROPBOX_USER'],
                         ENV['DROPBOX_PASS'],
                         'Public/Evensong')

        file = db.list.find {|f| f["name"] == "evensong_#{evensong.id}.pdf" }

        if (file)
          evensong.url = file['url']

          evensong.save
        end
      end
    end

    if (evensong.url)
      s = %{
      <a href="#{evensong.url}">PDF</a>
      }
    else
      s = "Ikke tilgjengelig"
    end
  end
end
