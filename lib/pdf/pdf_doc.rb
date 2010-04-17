require 'pdf/writer'
require 'pdf/simpletable'

class PDFDoc
  def initialize(items, title, headers)
    @items = items

    @date = Date.today().strftime("%Y-%m-%d")

    @title = title

    @headers = headers
  end

  def get_filename
    "#{@title.downcase}_#{@date}.pdf"
  end

  def get_document
    pdf = PDF::Writer.new(:paper => "A4", :orientation => :landscape)

    pdf.select_font("Helvetica", { :encoding => "WinAnsiEncoding" })

    table = PDF::SimpleTable.new
    table.title_font_size = 9
    table.heading_font_size = 7
    table.font_size = 7

    table.title = "#{@title} - #{@date}"

    table.data = []
    
    @items.each do |item|
      table.data << item
    end

    table.column_order = @headers.map { |header| header.title }

    table.render_on(pdf)

    pdf.render
  end
end