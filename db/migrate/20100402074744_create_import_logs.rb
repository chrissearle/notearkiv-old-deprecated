# coding: UTF-8

class CreateImportLogs < ActiveRecord::Migration
  def self.up
    create_table :import_logs do |t|
      t.string :field
      t.string :message
      t.integer :item

      t.timestamps
    end
  end

  def self.down
    drop_table :import_logs
  end
end
