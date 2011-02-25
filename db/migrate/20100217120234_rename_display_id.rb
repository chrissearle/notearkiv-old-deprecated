# coding: UTF-8

class RenameDisplayId < ActiveRecord::Migration
  def self.up
    rename_column :notes, :display_id, :item
  end

  def self.down
    rename_column :notes, :item, :display_id
  end
end
