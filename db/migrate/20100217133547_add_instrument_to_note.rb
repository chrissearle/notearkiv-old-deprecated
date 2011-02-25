# coding: UTF-8

class AddInstrumentToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :instrument_id, :integer
  end

  def self.down
    remove_column :notes, :instrument_id
  end
end
