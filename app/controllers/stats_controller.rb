class StatsController < ApplicationController
  filter_access_to :all

  def index
    archive = ArchiveConnection.new

    @stats = archive.stats
  end

end
