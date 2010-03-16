require 'spreadsheet'

class NoteSheet

  def initialize(headers, items, title, date, row_handler)
    @items = items

    @header_columns = headers

    @title = title
    @date = date

    @row_handler = row_handler

    @header_format = Spreadsheet::Format.new :weight => :bold,
                                             :align => :center
  end

  def get_spreadsheet
    @book = Spreadsheet::Workbook.new

    generate_sheet()

    generate_header_row()

    generate_rows()

    return write_to_temporary_file()
  end

  def get_filename
    "#{@title.downcase}_#{@date}.xls"
  end

  private

  def generate_sheet()
    @sheet = @book.create_worksheet
    @sheet.name = "#{@title} - #{@date}"
  end

  def generate_header_row()
    header = @sheet.row(0)

    header.default_format = @header_format

    col = 0

    @header_columns.each do |column|
      header.push column.title

      @sheet.column(col).width = column.width

      col += 1
    end
  end

  def generate_rows()
    @items.each do |item|
      row = @sheet.row(@sheet.last_row_index() + 1)

      @row_handler.call(row, item)
    end
  end

  def write_to_temporary_file()
    tmp_file = Tempfile.new(@title.downcase)

    @book.write(tmp_file)

    return tmp_file.path
  end


end