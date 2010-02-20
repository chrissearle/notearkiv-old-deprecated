#!/opt/local/bin/ruby

require 'rubygems'
require 'lib/archive/dropbox'

db = DropBox.new(ENV['DROPBOX_USER'],
                 ENV['DROPBOX_PASS'],
                 'Public/Evensong')

data = Hash.new


data.each do |file, oldfile|
  if FileTest.exists?(oldfile)
    db.create(oldfile)
    db.rename(oldfile, "#{file}.pdf")
  else
    print "Missing file #{oldfile} for file #{file}\n"
  end
end
