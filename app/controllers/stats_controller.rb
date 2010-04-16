require 'archive/archive'

class StatsController < ApplicationController
  filter_access_to :all

  def index
    # We can use any archive type - stats are global
    archive = Archive.new :note_archive, :document

    @stats = archive.stats
  end

end
