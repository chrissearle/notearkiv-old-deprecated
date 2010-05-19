require 'prawn/layout'

pdf.text "Evensongarkiv - #{Date.today().strftime("%Y-%m-%d")}", :size => 12, :style => :bold, :align => :center 

items = @evensongs.map do |note|
  [
          note.title,
          note.psalm,
          note.composer.blank? ? "" : note.composer.name,
          note.genre.blank? ? "" : note.genre.name
  ]
end

pdf.table items, :border_style => :grid, :font_size => 8, :padding => 2,
          :row_colors => ["FFFFFF", "DDDDDD"],
          :headers => ["Tittel", "Salme", "Komponist", "Genre"]

