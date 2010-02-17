#!/opt/local/bin/ruby

# ID:TITLE:VOICE:ORIG:COPY:INSTR:SOLO::PERIOD:GENRE:ACCOMP:LANG:SF:COMP

class String
  def escape_single_quotes
    self.gsub(/'/, "\\'")
  end
end


print "Note.create([";

sep = "\n";

File.open("notes.txt").each do |line|
  unless /^ID:/.match(line)
    parts = line.split(/:/)

    instruments = parts[9].split(/;/).join(", ")


    print "#{sep}{\n"
    print " :period => Period.find_by_name('#{parts[7]}'),\n" if parts[7] != ""
    print " :genre => Genre.find_by_name('#{parts[8]}'),\n" if parts[8] != ""
    print " :instrument => '#{instruments}',\n"
    print " :composer => Composer.find_by_name('#{parts[11]}'),\n" if parts[11] != ""
    print " :item => '#{parts[0]}',\n"
    print " :title => '#{parts[1].escape_single_quotes}',\n"
    print " :voice => '#{parts[2]}',\n"
    print " :count_originals => '#{parts[3]}',\n"
    print " :count_copies => '#{parts[4]}',\n"
    print " :count_instrumental => '#{parts[5]}'\n"
    print "}"

    sep = " ,\n";
  end
end

print "])";

