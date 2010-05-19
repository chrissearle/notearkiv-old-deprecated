require 'prawn/layout'

pdf.text "Notearkiv - #{Date.today().strftime("%Y-%m-%d")}", :size => 12, :style => :bold, :align => :center 

items = @notes.map do |note|
  [
          note.item,
          note.title,
          note.composer.blank? ? "" : note.composer.name,
          note.genre.blank? ? "" : note.genre.name,
          note.period.blank? ? "" : note.period.name,
          note.languages.map { |lang| lang.name }.join(", "),
          note.instrument
  ]
end

pdf.table items, :border_style => :grid, :font_size => 8, :padding => 2,
          :row_colors => ["FFFFFF", "DDDDDD"],
          :headers => ["ID", "Tittel", "Komponist", "Genre", "Epoke", "Språk", "Akkomp"]

