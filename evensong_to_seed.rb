#!/opt/local/bin/ruby

# PSALM:TITLE:FILE:EVENSONG

class String
  def escape_single_quotes
    self.gsub(/'/, "\\'")
  end

  def starts_with?(characters)
      self.match(/^#{characters}/) ? true : false
  end
end


print "Evensong.create([";

sep = "\n";

File.open("evensong.txt").each do |line|
  unless /^PSALM:/.match(line)
    parts = line.split(/:/)

    title = parts[1].escape_single_quotes

    if (parts[0] != "")
      title = title.sub(/^#{parts[0]} /, "")
    end

    print "#{sep}{\n"
    print " :psalm => '#{parts[0]}',\n" if parts[0] != ""
    print " :title => '#{title}',\n"
    print " :old_file_path => '#{parts[2]}'\n"
    print "}"

    sep = " ,\n";
  end
end

print "])\n";

