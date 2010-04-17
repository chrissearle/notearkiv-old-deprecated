require 'pdf/writer'

class PDFDoc
  def initialize(items, title, item_handler)
    @items = items

    @date = Date.today().strftime("%Y-%m-%d")

    @title = title

    @handler = item_handler
  end

  def get_filename
    "#{@title.downcase}_#{@date}.pdf"
  end

  def get_document
    pdf = PDF::Writer.new

    pdf.text @title

    pdf.render
  end
end