require 'iconv'

class String
  def to_latin1
    Iconv.iconv("LATIN1", "UTF-8", self)
  end
end
