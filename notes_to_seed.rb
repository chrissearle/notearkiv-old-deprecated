#!/opt/local/bin/ruby

# ID:TITLE:VOICE:ORIG:COPY:INSTR:SOLO:PERIOD:GENRE:ACCOMP:LANG:SF:COMP

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
    
    print "#{sep}{\n"
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

