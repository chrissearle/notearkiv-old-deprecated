require 'spreadsheet'

module Exceptions
  class IncorrectMimetype < StandardError
    def message()
      "Opplastet fil må være en excel ark"
    end
  end

  class IncorrectHeader < StandardError
    def message()
      "Opplastet fil må være en excel ark med samme første rad som nedlastet fil"
    end
  end
end

class Importer
  def initialize(file, headers)
    raise Exceptions::IncorrectMimetype unless file.content_type == "application/vnd.ms-excel"

    @headers = headers

    book = Spreadsheet.open file.path

    @sheet = book.worksheet 0

    check_header
  end

  def rows
    rows = Array.new

    @sheet.each 1 do |row|
      # This Array.new forces reading row as array - reads the values and discards all spreadsheet extras
      rows << Array.new(row)
    end

    rows
  end

  private

  def check_header
    row = @sheet.row(0)

    raise Exceptions::IncorrectHeader unless row.eql? @headers
  end
end