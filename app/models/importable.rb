# coding: UTF-8

module Importable
  def import_item(item, row)
    populate_from_import(item)

    if (!save)
      errors.each do |attr, msg|
        import_log = ImportLog.new(:field => attr, :message => msg, :item => row)
        import_log.save
      end
    end
  end
end