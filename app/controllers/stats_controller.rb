require 'archive/archive'

class StatsController < ApplicationController
  def index
    # We can use any archive type - stats are global
    archive = Archive.new :note_archive, :document

    stats = archive.stats

    # In 0.0.6 dropbox gem used is coming back in bytes not gb's and the free calculation is not taking account of this

    @percent = stats[:percent]
    @total = stats[:total]
    @used = stats[:used] / (1024*1024)
    @free = @total - @used
  end

end
