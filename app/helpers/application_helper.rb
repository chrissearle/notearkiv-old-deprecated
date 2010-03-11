module ApplicationHelper
  def list_link_dropbox_files(object)
    if (object.doc_url.blank? && object.music_url.blank?)
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

  def archive_stats
    # We can use any archive type - stats are global

    archive = Archive.new :note_archive, :document

    stats = archive.stats

    # In 0.0.6 dropbox gem used is coming back in bytes not gb's and the free calculation is not taking account of this

    used = stats[:used] / (1024*1024)
    free = stats[:total] - used

    s = %{
      <dl>
        <dt>Percentage Used</dt>
        <dd>#{stats[:percent]}</dd>

        <dt>Used</dt>
        <dd>#{"%.2f" % used} GB</dd>

        <dt>Free</dt>
        <dd>#{"%.2f" % free} GB</dd>

        <dt>Total</dt>
        <dd>#{"%.2f" % stats[:total]} GB</dd>
    }
  end
end
