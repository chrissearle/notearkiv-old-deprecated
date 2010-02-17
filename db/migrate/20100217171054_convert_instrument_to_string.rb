class ConvertInstrumentToString < ActiveRecord::Migration
  def self.up
    remove_column :notes, :instrument_id
    add_column :notes, :instrument, :string
  end

  def self.down
    add_column :notes, :instrument_id, :integer
    remove_column :notes, :instrument
  end
end
