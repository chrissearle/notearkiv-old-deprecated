# coding: UTF-8

class RemoveOldFilePathFromEvensongs < ActiveRecord::Migration
  def self.up
    remove_column :evensongs, :old_file_path
  end

  def self.down
    add_column :evensongs, :old_file_path, :string
  end
end
