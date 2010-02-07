require 'dropbox'

module EvensongsHelper
  def link_to_evensong_file(evensong)

    if (evensong.url.nil? || evensong.url == "")
      db = DropBox.new('chris+notearkiv.ochs.no@chrissearle.org',
                   'bei1Ahng',
                   'Public/Evensong')

      file = db.list.find {|f| f["name"] == "evensong_#{evensong.id}.pdf" }

      if (file)
        evensong.url = file['url']

        evensong.save
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
